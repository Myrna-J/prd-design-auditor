# /tdd - 测试驱动开发（TDD）工作流指导

## 功能

引导你完成标准的 TDD 开发流程：**RED → GREEN → REFACTOR → E2E-VERIFY**

---

## 使用方式

```bash
/tdd
/tdd --lang=python
/tdd --skip-e2e
/tdd "实现用户登录功能"
```

---

## 参数说明

| 参数 | 说明 | 可选值 | 默认值 |
|------|------|--------|--------|
| `--lang` | 编程语言 | `python`, `typescript`, `go`, `javascript` | 自动检测 |
| `--skip-e2e` | 跳过 E2E 验证 | - | false |
| `--focus` | 专注阶段 | `red`, `green`, `refactor`, `all` | `all` |

---

## TDD 循环流程

### 📌 阶段 1: RED（编写失败测试）

**目标**: 编写一个**失败的**测试，描述你想要实现的功能。

**任务**:
1. 分析需求，确定要实现的功能
2. 编写测试用例，描述预期行为
3. 运行测试，确认它**失败**（RED）

**示例**:

```python
# tests/test_calculator.py
def test_add_two_numbers():
    """测试两个数相加"""
    result = add(2, 3)
    assert result == 5
```

```bash
# 运行测试（应该失败）
pytest tests/test_calculator.py -v

# ❌ FAILED - NameError: name 'add' is not defined
```

**检查清单**:
- [ ] 测试描述清晰，符合业务需求
- [ ] 测试当前会失败
- [ ] 失败原因是**功能未实现**，而非测试错误

---

### 🟢 阶段 2: GREEN（最小实现）

**目标**: 编写**最少**的代码使测试通过。

**任务**:
1. 实现功能，只关注**通过测试**
2. 不要考虑代码质量、边界情况
3. 运行测试，确认它**通过**（GREEN）

**示例**:

```python
# calculator.py
def add(a, b):
    return a + b
```

```bash
# 运行测试（应该通过）
pytest tests/test_calculator.py -v

# ✅ PASSED test_add_two_numbers
```

**检查清单**:
- [ ] 测试通过
- [ ] 代码是最小实现
- [ ] 没有过度设计

---

### 🔄 阶段 3: REFACTOR（重构优化）

**目标**: 改善代码质量，同时保持测试通过。

**任务**:
1. 审查代码，识别改进点
2. 重构：提取方法、优化逻辑、添加类型注解
3. 运行测试，确认**仍然通过**

**示例**:

```python
# calculator.py (重构后)
from typing import Union

def add(a: Union[int, float], b: Union[int, float]) -> Union[int, float]:
    """将两个数相加

    Args:
        a: 第一个数
        b: 第二个数

    Returns:
        两数之和
    """
    return a + b
```

```bash
# 运行测试（仍然应该通过）
pytest tests/test_calculator.py -v

# ✅ PASSED test_add_two_numbers
```

**检查清单**:
- [ ] 测试仍然通过
- [ ] 代码更清晰、可维护
- [ ] 添加了必要的文档和类型注解

---

### ✅ 阶段 4: E2E-VERIFY（端到端验证）

**目标**: 验证功能在完整系统中正常工作。

**任务**:
1. 自动调用 `/e2e` 命令
2. 运行相关的端到端测试
3. 如果失败：分析原因并修复
4. 如果通过：提交代码

**示例**:

```bash
# 自动触发 E2E 测试
/e2e --flow=user-login

# ✅ 所有 E2E 测试通过
```

**检查清单**:
- [ ] 相关的 E2E 测试通过
- [ ] 功能在真实场景中正常工作
- [ ] 没有引入回归问题

---

## 完整示例

### 场景：实现用户登录功能

```bash
# 开始 TDD 流程
/tdd "实现用户登录功能"
```

#### 1. RED - 编写失败测试

```python
# tests/test_auth.py
import pytest

def test_user_login_with_valid_credentials():
    """测试有效凭据登录"""
    response = login("user@example.com", "password123")
    assert response["success"] is True
    assert "token" in response

def test_user_login_with_invalid_credentials():
    """测试无效凭据登录"""
    response = login("user@example.com", "wrong_password")
    assert response["success"] is False
    assert response["error"] == "Invalid credentials"
```

```bash
# 运行测试（失败）
pytest tests/test_auth.py -v

# ❌ NameError: name 'login' is not defined
```

#### 2. GREEN - 最小实现

```python
# auth.py
def login(email, password):
    """用户登录"""
    # 最小实现，只为了让测试通过
    if email == "user@example.com" and password == "password123":
        return {"success": True, "token": "fake_token"}
    return {"success": False, "error": "Invalid credentials"}
```

```bash
# 运行测试（通过）
pytest tests/test_auth.py -v

# ✅ PASSED test_user_login_with_valid_credentials
# ✅ PASSED test_user_login_with_invalid_credentials
```

#### 3. REFACTOR - 重构优化

```python
# auth.py (重构后)
from typing import Dict
import hashlib

class AuthService:
    def __init__(self, db):
        self.db = db

    def login(self, email: str, password: str) -> Dict:
        """验证用户凭据并返回认证令牌

        Args:
            email: 用户邮箱
            password: 用户密码

        Returns:
            包含 success 状态和 token/error 的字典
        """
        user = self.db.get_user_by_email(email)
        if not user:
            return {"success": False, "error": "User not found"}

        if not self._verify_password(password, user["password_hash"]):
            return {"success": False, "error": "Invalid credentials"}

        token = self._generate_token(user)
        return {"success": True, "token": token}

    def _verify_password(self, password: str, password_hash: str) -> bool:
        """验证密码"""
        return hashlib.sha256(password.encode()).hexdigest() == password_hash

    def _generate_token(self, user: Dict) -> str:
        """生成认证令牌"""
        # 实际实现应使用 JWT
        return f"token_{user['id']}"
```

```bash
# 运行测试（仍然通过）
pytest tests/test_auth.py -v

# ✅ PASSED test_user_login_with_valid_credentials
# ✅ PASSED test_user_login_with_invalid_credentials
```

#### 4. E2E-VERIFY - 端到端验证

```bash
# 运行 E2E 测试
/e2e --flow=user-login

# ✅ 所有 E2E 测试通过

# 查看覆盖率
/test-coverage

# 📊 覆盖率: 95.3%
```

---

## TDD 最佳实践

### ✅ 应该做的

1. **小步前进**: 每次只实现一个功能点
2. **测试先行**: 永远先写测试，再写代码
3. **保持简单**: GREEN 阶段不要过度设计
4. **持续重构**: REFACTOR 阶段改善代码质量
5. **高覆盖率**: 核心业务逻辑覆盖率 ≥ 80%

### ❌ 不应该做的

1. **跳过测试**: 不要说"稍后补测试"
2. **编写假测试**: 测试应该描述真实行为
3. **在 GREEN 阶段重构**: 专注于通过测试
4. **忽略失败的测试**: 失败的测试必须立即修复
5. **测试实现细节**: 测试行为，而非实现

---

## 与其他命令配合

### 与 /e2e 配合
```bash
/tdd "实现购物车功能" → 自动触发 E2E 验证
```

### 与 /verify 配合
```bash
/tdd → /verify  # 完整的质量检查
```

### 与 /test-coverage 配合
```bash
/tdd → /test-coverage  # 检查覆盖率
```

---

## 测试覆盖率要求

- **核心业务逻辑**: ≥ 80%
- **工具函数**: ≥ 90%
- **配置文件**: 不要求

查看覆盖率：
```bash
/test-coverage
```

---

## 故障排查

### 问题：测试总是通过，无法进入 RED 状态

**原因**: 测试断言不正确或测试假阳性

**解决**:
- 检查测试断言是否正确
- 确保测试在功能未实现时会失败
- 添加边界条件测试

### 问题：GREEN 阶段无法通过测试

**原因**: 测试描述不清楚或需求理解错误

**解决**:
- 重新审查测试描述
- 与产品/业务确认需求
- 调整测试用例

### 问题：REFACTOR 后测试失败

**原因**: 重构改变了功能行为

**解决**:
- 撤销重构代码
- 逐步重构，每次重构后运行测试
- 确保重构不改变功能行为

---

## 参考资源

- **TDD 原则**: `.claude/rules/common/testing.md`
- **测试覆盖率**: `/test-coverage` 命令
- **代码验证**: `/verify` 命令
- **E2E 测试**: `/e2e` 命令

---

*命令版本: 1.0.0*
*更新日期: 2026-03-05*
