export const dengJi = [{id: 1, name: 'A'}, {id: 2, name: 'B'}, {id: 3, name: 'C'}],
stateColor = ['', 'red', 'orange', 'orange', 'green'],
//权限掩码: 1 质检员数据输入, 2 检修员签收 4 管理员
PERMISSION_DATA = 1, PERMISSION_REPAIR = 2, PERMISSION_MANAGE = 4,
permissions = [{
  id: PERMISSION_DATA,
  name: '数据',
  color: 'green'
}, {
  id: PERMISSION_REPAIR,
  name: '检修',
  color: 'blue'
}, {
  id: PERMISSION_MANAGE,
  name: '管理',
  color: 'red'
}],
USER_STATE_APPLY_RESET_PASSWORD = 1,
USER_STATE_APPROVED_RESET_PASSWORD = 2,
//已下发, 已处理, 已复检
dispatched = 1, checkedin = 2, rejected = 3, resolved = 4,
chuLiStates = [{
  id: 0,
  name: ''
}, {
  id: dispatched,
  name: '已下发'
}, {
  id: checkedin,
  name: '已处理'
}, {
  id: rejected,
  name: '复检不合格'
}, {
  id: resolved,
  name: '复检合格'
}],
peiJianLeiBie = [{
  id: 1,
  name: '必检'
}, {
  id: 2,
  name: '抽检'
}]
