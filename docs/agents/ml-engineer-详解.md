# ml-engineer Agent 详解

<div align="center">

**机器学习工程专业代理**

⭐⭐⭐⭐⭐ 算法必备 | 官方 Agent

</div>

---

## 简体中文

### 📖 Agent 简介

**ml-engineer** 专注于**生产级机器学习系统**，从模型训练到部署的完整pipeline。

**核心能力**：
- ✅ 训练Pipeline设计
- ✅ 模型优化与调参
- ✅ 模型部署与服务化
- ✅ 性能监控

### 💡 使用示例

#### 示例：完整训练Pipeline

**输入**：
```
使用 ml-engineer 创建图像分类训练pipeline
```

**输出**：
```python
import torch
import torch.nn as nn
from torch.utils.data import DataLoader
from torchvision import datasets, transforms
import wandb
from pathlib import Path

class ImageClassificationPipeline:
    def __init__(self, config):
        self.config = config
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        
        # 初始化wandb实验跟踪
        wandb.init(project='image-classification', config=config)
        
    def setup_data(self):
        """数据准备"""
        transform_train = transforms.Compose([
            transforms.RandomCrop(32, padding=4),
            transforms.RandomHorizontalFlip(),
            transforms.ToTensor(),
            transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5))
        ])
        
        transform_test = transforms.Compose([
            transforms.ToTensor(),
            transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5))
        ])
        
        train_dataset = datasets.CIFAR10(
            root='./data', train=True, download=True, transform=transform_train
        )
        test_dataset = datasets.CIFAR10(
            root='./data', train=False, download=True, transform=transform_test
        )
        
        self.train_loader = DataLoader(
            train_dataset, batch_size=self.config['batch_size'],
            shuffle=True, num_workers=4
        )
        self.test_loader = DataLoader(
            test_dataset, batch_size=self.config['batch_size'],
            shuffle=False, num_workers=4
        )
        
    def build_model(self):
        """构建模型"""
        from torchvision.models import resnet18
        model = resnet18(pretrained=False, num_classes=10)
        return model.to(self.device)
        
    def train_epoch(self, model, optimizer, criterion, epoch):
        """训练一个epoch"""
        model.train()
        total_loss = 0
        correct = 0
        total = 0
        
        for batch_idx, (inputs, targets) in enumerate(self.train_loader):
            inputs, targets = inputs.to(self.device), targets.to(self.device)
            
            optimizer.zero_grad()
            outputs = model(inputs)
            loss = criterion(outputs, targets)
            loss.backward()
            optimizer.step()
            
            total_loss += loss.item()
            _, predicted = outputs.max(1)
            total += targets.size(0)
            correct += predicted.eq(targets).sum().item()
            
            if batch_idx % 100 == 0:
                print(f'Epoch: {epoch} [{batch_idx}/{len(self.train_loader)}] '
                      f'Loss: {loss.item():.3f} Acc: {100.*correct/total:.2f}%')
                
        return total_loss / len(self.train_loader), 100. * correct / total
        
    def validate(self, model, criterion):
        """验证"""
        model.eval()
        test_loss = 0
        correct = 0
        total = 0
        
        with torch.no_grad():
            for inputs, targets in self.test_loader:
                inputs, targets = inputs.to(self.device), targets.to(self.device)
                outputs = model(inputs)
                loss = criterion(outputs, targets)
                
                test_loss += loss.item()
                _, predicted = outputs.max(1)
                total += targets.size(0)
                correct += predicted.eq(targets).sum().item()
                
        return test_loss / len(self.test_loader), 100. * correct / total
        
    def train(self):
        """完整训练流程"""
        model = self.build_model()
        criterion = nn.CrossEntropyLoss()
        optimizer = torch.optim.Adam(model.parameters(), lr=self.config['lr'])
        scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(
            optimizer, T_max=self.config['epochs']
        )
        
        best_acc = 0
        for epoch in range(self.config['epochs']):
            train_loss, train_acc = self.train_epoch(model, optimizer, criterion, epoch)
            test_loss, test_acc = self.validate(model, criterion)
            scheduler.step()
            
            # 记录到wandb
            wandb.log({
                'train_loss': train_loss,
                'train_acc': train_acc,
                'test_loss': test_loss,
                'test_acc': test_acc,
                'lr': optimizer.param_groups[0]['lr']
            })
            
            # 保存最佳模型
            if test_acc > best_acc:
                best_acc = test_acc
                torch.save({
                    'epoch': epoch,
                    'model_state_dict': model.state_dict(),
                    'optimizer_state_dict': optimizer.state_dict(),
                    'acc': best_acc,
                }, 'best_model.pth')
                
        print(f'Best Accuracy: {best_acc:.2f}%')
        return model

# 使用
config = {
    'batch_size': 128,
    'lr': 0.001,
    'epochs': 100
}

pipeline = ImageClassificationPipeline(config)
pipeline.setup_data()
model = pipeline.train()
```

### ✨ 为什么推荐

1. **生产就绪** 🎯 - Pipeline化、可复现
2. **实验管理** 📊 - W&B集成、版本控制
3. **性能优化** ⚡ - 数据并行、混合精度
4. **部署友好** 🚀 - 模型导出、服务化

---

**Made with ❤️ for ML engineers**
