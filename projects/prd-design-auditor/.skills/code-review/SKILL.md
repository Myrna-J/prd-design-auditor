# /code-review - 代码审查

## 功能

执行全面的代码审查：**安全 + 逻辑 + 风格 + 性能 + 简化性**

> **v2.1.71 增强**：集成 `/simplify` 技能，自动检测可简化的代码模式

---

## 使用方式

```bash
/code-review
/code-review --file src/auth.py
/code-review --focus security
/code-review --auto-fix
```

---

## 参数说明

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `--file` | 指定审查文件路径 | 当前所有修改 |
| `--focus` | 聚焦特定领域 | security,logic,style,simplify,performance |
| `--auto-fix` | 自动修复可简化代码 | false |
| `--severity` | 只显示指定级别以上问题 | info |

---

## 审查流程

### 1. 安全性检查（CRITICAL）

**优先级**: 🔴 CRITICAL

检查项：
- [ ] **密钥泄露**：硬编码的 API Keys、Passwords、Tokens
- [ ] **注入攻击**：SQL 拼接、Command Injection
- [ ] **输入验证**：所有外部输入是否验证？
- [ ] **敏感数据**：日志中是否泄露敏感信息？

**输出格式**：
```
🔴 严重问题（必须修复）

1. [密钥泄露] src/auth.py:45
   硬编码的 API Key: sk-proj-abc123...
   建议: 使用环境变量替代

2. [SQL 注入] src/user.py:78
   直接拼接 SQL: f"SELECT * FROM users WHERE id = {user_id}"
   修复: 使用参数化查询
```

---

### 2. 简化性检查（NEW - v2.1.71）

**优先级**: ⚠️ WARN

**调用 `/simplify` 技能**，检查以下代码模式：

#### 2.1 深层嵌套

**问题**: 嵌套层级 > 4

```python
# ❌ 当前: 5层嵌套
def process_data(data):
    if data:
        if 'items' in data:
            for item in data['items']:
                if item['active']:
                    if item['verified']:
                        do_something(item)

# ✅ 建议: 使用早返回
def process_data(data):
    if not data:
        return
    if 'items' not in data:
        return
    for item in data['items']:
        if not item['active']:
            continue
        if not item['verified']:
            continue
        do_something(item)
```

#### 2.2 过长函数

**问题**: 函数行数 > 50

```python
# ❌ 当前: 78行
def handle_request(request):
    # ... 78 行代码

# ✅ 建议: 拆分为多个函数
def handle_request(request):
    validate_request(request)  # 15行
    data = process_request(request)  # 30行
    return format_response(data)  # 15行
```

#### 2.3 重复代码

**问题**: 相似代码段出现 > 2次

```python
# ❌ 当前: 重复的逻辑
if user_type == 'admin':
    send_email(user.email, '欢迎管理员')
    log_action(user.id, 'admin_login')
    update_stats('admin_count')
elif user_type == 'moderator':
    send_email(user.email, '欢迎版主')
    log_action(user.id, 'moderator_login')
    update_stats('moderator_count')

# ✅ 建议: 提取通用函数
def handle_user_login(user, role):
    send_email(user.email, f'欢迎{role}')
    log_action(user.id, f'{role}_login')
    update_stats(f'{role}_count')
```

#### 2.4 复杂条件

**问题**: 条件表达式过于复杂

```python
# ❌ 当前: 复杂的布尔表达式
if (user.age >= 18 and user.country == 'CN' and
    (user.has_id or user.has_passport) and
    not user.blacklisted):

# ✅ 建议: 提取为函数
def is_eligible_user(user):
    return (
        user.age >= 18 and
        user.country == 'CN' and
        (user.has_id or user.has_passport) and
        not user.blacklisted
    )

if is_eligible_user(user):
```

#### 2.5 魔法数字

**问题**: 未命名的数字常量

```python
# ❌ 当前
if elapsed_time > 86400000:
    send_notification()

# ✅ 建议: 使用常量
MILLISECONDS_PER_DAY = 86400000
if elapsed_time > MILLISECONDS_PER_DAY:
    send_notification()
```

**输出格式**：
```
⚠️  简化建议（可优化）

1. [深层嵌套] src/user.py:23-45 (5层)
   建议: 使用早返回或卫语句简化

2. [过长函数] src/auth.py:78-156 (78行)
   建议: 拆分为:
     - validate_credentials() - 15行
     - check_permissions() - 30行
     - create_session() - 20行

3. [重复代码] src/api.py:45, 78, 102
   相似代码段出现3次，建议提取为函数:
     - send_notification(user, type)

4. [复杂条件] src/utils.py:67
   条件过于复杂，建议提取为函数:
     - is_eligible_for_discount(user, order)

5. [魔法数字] src/config.py:12
   未命名常量: 86400000
   建议: 定义 MILLISECONDS_PER_DAY
```

---

### 3. 逻辑与正确性

**优先级**: 🟡 HIGH

检查项：
- [ ] **边界条件**：空列表、Null、0、负数
- [ ] **异常处理**：是否有 bare `except:`？
- [ ] **资源泄漏**：文件句柄、数据库连接是否正确关闭？

---

### 4. 代码风格

**优先级**: 🔵 INFO

检查项：
- [ ] **命名规范**：变量名是否清晰？
- [ ] **中文注释**：关键逻辑是否有中文解释？
- [ ] **代码格式**：是否符合 PEP 8 / ESLint 规则？

---

### 5. 性能

**优先级**: 🟢 LOW

检查项：
- [ ] **循环优化**：N+1 查询问题
- [ ] **算法复杂度**：不必要的嵌套循环（O(n^2)）

---

## 完整输出示例

```bash
/code-review --file src/auth.py
```

```
🔍 代码审查报告: src/auth.py

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### 📊 总体评分: 6.5/10

#### 评分明细:
  - 安全性:     7/10  (发现1个中危问题)
  - 简化性:     5/10  (发现3个可优化项)
  - 正确性:     8/10  (边界条件处理良好)
  - 代码风格:   7/10  (部分注释缺失)
  - 性能:       8/10  (无明显性能问题)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### 🔴 严重问题（必须修复）

1. [密钥泄露] Line 45
   ```python
   API_KEY = "sk-proj-abc123def456..."  # ❌ 硬编码
   ```
   **修复建议**:
   ```python
   API_KEY = os.environ.get("API_KEY")
   if not API_KEY:
       raise ValueError("API_KEY 未配置")
   ```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### ⚠️  简化建议（可优化）

1. [深层嵌套] Lines 23-45 (5层嵌套)
   ```python
   # ❌ 当前
   def validate_user(user):
       if user:
           if user.is_active:
               if user.email:
                   if user.email_verified:
                       return True
   ```

   **修复建议**:
   ```python
   # ✅ 使用早返回
   def validate_user(user):
       if not user:
           return False
       if not user.is_active:
           return False
       if not user.email:
           return False
       if not user.email_verified:
           return False
       return True
   ```

2. [过长函数] Lines 78-156 (78行)
   **建议拆分**:
   - `validate_credentials(user, password)` - 18行
   - `check_permissions(user, resource)` - 25行
   - `create_session(user)` - 20行

3. [重复代码] Lines 45, 67, 89
   **相似日志记录代码出现3次**
   **建议提取为**:
   ```python
   def log_auth_action(action, user_id, success):
       logger.info(
           f"Auth {action}: user_id={user_id}, success={success}"
       )
   ```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### 🟡 改进建议

1. [边界条件] Line 102
   未处理空列表情况:
   ```python
   # 当前
   def get_first_item(items):
       return items[0]  # ❌ 可能在空列表时报错

   # 建议
   def get_first_item(items):
       return items[0] if items else None
   ```

2. [中文注释] Lines 34-67
   缺少关键逻辑注释，建议添加中文说明

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### ✅ 做得好的地方

1. ✓ 正确使用 `with` 语句管理资源
2. ✓ 异常处理完整，未使用 bare `except`
3. ✓ 变量命名清晰，语义明确

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 📈 自动修复模式

使用 `/code-review --auto-fix` 自动修复可简化代码：

**自动修复内容**:
- ✓ 深层嵌套 → 早返回
- ✓ 重复代码 → 提取函数
- ✓ 魔法数字 → 命名常量

**不自动修复**:
- ✗ 安全问题（需人工审核）
- ✗ 业务逻辑错误
- ✗ 复杂的重构

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 下一步:
  1. 修复1个严重问题（密钥泄露）
  2. 优化3个简化建议项
  3. 运行 `/code-review --auto-fix` 自动应用简化修复
```

---

## 自动修复模式

使用 `--auto-fix` 参数自动修复可简化的代码：

```bash
/code-review --auto-fix
```

**自动修复流程**：
1. 调用 `/simplify` 技能分析代码
2. 应用以下自动修复：
   - 深层嵌套 → 早返回/卫语句
   - 重复代码 → 提取函数
   - 魔法数字 → 命名常量
   - 复杂条件 → 提取布尔函数
3. 生成修复后的代码对比

**不自动修复**（需人工确认）：
- 安全问题
- 业务逻辑修改
- 大规模重构

---

## 集成到 Git Hooks

在提交前自动运行代码审查：

```bash
# .git/hooks/pre-commit
#!/bin/bash

# 只审查 staged 的文件
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.py$')

if [ -n "$STAGED_FILES" ]; then
    echo "🔍 运行代码审查..."
    /code-review --file $STAGED_FILES

    if [ $? -ne 0 ]; then
        echo "❌ 代码审查失败，请修复问题后再次提交"
        exit 1
    fi
fi
```

---

## 与 `/verify` 命令配合

**推荐工作流**：
1. 本地开发完成后，运行 `/code-review` 检查代码质量
2. 修复严重问题和简化建议
3. 运行 `/verify` 执行完整验证（测试 + Lint + 安全）
4. 提交代码

---

## 参考资源

- **编码规范**: `.claude/rules/common/coding-style.md`
- **代码审查清单**: `.claude/rules/common/code_review.md`
- **简化技能**: `/simplify` (v2.1.71)
- **全管道验证**: `/verify`

---

*命令版本: 2.0.0*
*更新日期: 2026-03-09*
*更新内容: 集成 /simplify 技能，新增简化性检查*
