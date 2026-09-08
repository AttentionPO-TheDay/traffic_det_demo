TRUNCATE TABLE sys_menu;
TRUNCATE TABLE sys_role;
TRUNCATE TABLE sys_role_dept;
TRUNCATE TABLE sys_role_menu;
TRUNCATE TABLE sys_user;
TRUNCATE TABLE sys_user_post;
TRUNCATE TABLE sys_user_role;

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1, '系统管理', 0, 1, 'system', null, 1, 0, 'M', '0', '0', '', 'system', 'admin', '2021-11-24 13:59:26', '',
        null, '系统管理目录');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2, '系统监控', 0, 2, 'monitor', null, 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2021-11-24 13:59:26', '',
        null, '系统监控目录');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (3, '系统工具', 0, 3, 'tool', null, 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2021-11-24 13:59:26', '', null,
        '系统工具目录');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (4, '若依官网', 0, 4, 'http://ruoyi.vip', null, 0, 0, 'M', '0', '0', '', 'guide', 'admin', '2021-11-24 13:59:26',
        '', null, '若依官网地址');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin',
        '2021-11-24 13:59:26', '', null, '用户管理菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin',
        '2021-11-24 13:59:26', '', null, '角色管理菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table',
        'admin', '2021-11-24 13:59:26', '', null, '菜单管理菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin',
        '2021-11-24 13:59:26', '', null, '部门管理菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin',
        '2021-11-24 13:59:26', '', null, '岗位管理菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin',
        '2021-11-24 13:59:26', '', null, '字典管理菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', 1, 0, 'C', '0', '0', 'system:config:list', 'edit',
        'admin', '2021-11-24 13:59:26', '', null, '参数设置菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', 1, 0, 'C', '0', '0', 'system:notice:list', 'message',
        'admin', '2021-11-24 13:59:26', '', null, '通知公告菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (108, '日志管理', 1, 9, 'log', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2021-11-24 13:59:26', '', null,
        '日志管理菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online',
        'admin', '2021-11-24 13:59:26', '', null, '在线用户菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin',
        '2021-11-24 13:59:26', '', null, '定时任务菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid',
        'admin', '2021-11-24 13:59:26', '', null, '数据监控菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server',
        'admin', '2021-11-24 13:59:26', '', null, '服务监控菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis',
        'admin', '2021-11-24 13:59:26', '', null, '缓存监控菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (114, '表单构建', 3, 1, 'build', 'tool/build/index', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin',
        '2021-11-24 13:59:26', '', null, '表单构建菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (115, '代码生成', 3, 2, 'gen', 'tool/gen/index', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin',
        '2021-11-24 13:59:26', '', null, '代码生成菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (116, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger',
        'admin', '2021-11-24 13:59:26', '', null, '系统接口菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', 1, 0, 'C', '0', '0', 'monitor:operlog:list',
        'form', 'admin', '2021-11-24 13:59:26', '', null, '操作日志菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', 1, 0, 'C', '0', '0',
        'monitor:logininfor:list', 'logininfor', 'admin', '2021-11-24 13:59:26', '', null, '登录日志菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1001, '用户查询', 100, 1, '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1002, '用户新增', 100, 2, '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1003, '用户修改', 100, 3, '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1004, '用户删除', 100, 4, '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1005, '用户导出', 100, 5, '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1006, '用户导入', 100, 6, '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1007, '重置密码', 100, 7, '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1008, '角色查询', 101, 1, '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1009, '角色新增', 101, 2, '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1010, '角色修改', 101, 3, '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1011, '角色删除', 101, 4, '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1012, '角色导出', 101, 5, '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1013, '菜单查询', 102, 1, '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1014, '菜单新增', 102, 2, '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1015, '菜单修改', 102, 3, '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1016, '菜单删除', 102, 4, '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1017, '部门查询', 103, 1, '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1018, '部门新增', 103, 2, '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1019, '部门修改', 103, 3, '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1020, '部门删除', 103, 4, '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1021, '岗位查询', 104, 1, '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1022, '岗位新增', 104, 2, '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1023, '岗位修改', 104, 3, '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1024, '岗位删除', 104, 4, '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1025, '岗位导出', 104, 5, '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1026, '字典查询', 105, 1, '#', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1027, '字典新增', 105, 2, '#', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1028, '字典修改', 105, 3, '#', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1029, '字典删除', 105, 4, '#', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1030, '字典导出', 105, 5, '#', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1031, '参数查询', 106, 1, '#', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1032, '参数新增', 106, 2, '#', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1033, '参数修改', 106, 3, '#', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1034, '参数删除', 106, 4, '#', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1035, '参数导出', 106, 5, '#', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1036, '公告查询', 107, 1, '#', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1037, '公告新增', 107, 2, '#', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1038, '公告修改', 107, 3, '#', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1039, '公告删除', 107, 4, '#', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1040, '操作查询', 500, 1, '#', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1041, '操作删除', 500, 2, '#', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1042, '日志导出', 500, 4, '#', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1043, '登录查询', 501, 1, '#', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1044, '登录删除', 501, 2, '#', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1045, '日志导出', 501, 3, '#', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1046, '在线查询', 109, 1, '#', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1047, '批量强退', 109, 2, '#', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1048, '单条强退', 109, 3, '#', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1049, '任务查询', 110, 1, '#', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1050, '任务新增', 110, 2, '#', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1051, '任务修改', 110, 3, '#', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1052, '任务删除', 110, 4, '#', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1053, '状态修改', 110, 5, '#', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1054, '任务导出', 110, 7, '#', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin',
        '2021-11-24 13:59:26', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1055, '生成查询', 115, 1, '#', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1056, '生成修改', 115, 2, '#', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1057, '生成删除', 115, 3, '#', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1058, '导入代码', 115, 2, '#', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1059, '预览代码', 115, 4, '#', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (1060, '生成代码', 115, 5, '#', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2021-11-24 13:59:26',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2000, '威胁检索', 0, 100, 'threat', null, 1, 0, 'M', '0', '0', null, 'dashboard', 'admin',
        '2021-11-24 14:10:12', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2001, '威胁总览', 2000, 100, 'overview', 'threat/overview/index', 1, 0, 'C', '0', '0', '', 'chart', 'admin',
        '2021-11-24 14:11:10', 'admin', '2021-11-24 14:33:09', '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2002, '风险资产', 2000, 200, 'danger-asset', 'threat/danger-asset/index', 1, 0, 'C', '0', '0', '', 'bug',
        'admin', '2021-11-24 14:11:26', 'admin', '2021-11-24 14:33:31', '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2003, '威胁检索', 2000, 300, 'search', 'threat/search/index', 1, 0, 'C', '0', '0', '', 'search', 'admin',
        '2021-11-24 14:11:43', 'admin', '2021-11-24 14:33:35', '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2004, '加密协议分析', 0, 200, 'protocol', null, 1, 0, 'M', '0', '0', null, 'date-range', 'admin',
        '2021-11-24 14:12:29', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2005, '流量总览', 2004, 100, 'overview', 'protocol/overview/index', 1, 0, 'C', '0', '0', '', 'code', 'admin',
        '2021-11-24 14:12:57', 'admin', '2021-11-24 14:33:44', '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2006, 'TLS 流量', 2004, 200, 'overview/tls', 'protocol/overview/index', 1, 0, 'C', '0', '0', '', 'validCode',
        'admin', '2021-11-24 14:30:47', 'admin', '2021-11-24 14:34:15', '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2007, 'IPSec 流量', 2004, 300, 'overview/ipsec', 'protocol/overview/index', 1, 0, 'C', '0', '0', null, 'online',
        'admin', '2021-11-24 14:34:59', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2008, 'SSH 流量', 2004, 400, 'overview/ssh', 'protocol/overview/index', 1, 0, 'C', '0', '0', '', 'upload',
        'admin', '2021-11-24 14:35:16', 'admin', '2021-11-24 15:06:23', '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2009, '系统运维', 0, 300, 'configuration', null, 1, 0, 'M', '0', '0', null, 'system', 'admin',
        '2021-11-24 14:37:38', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2010, '探针管理', 2009, 100, 'sensor', 'configuration/sensor/index', 1, 0, 'C', '0', '0', null, 'code', 'admin',
        '2021-11-24 14:38:02', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2011, '流量识别管理', 2009, 200, 'identifier', 'configuration/identifier/index', 1, 0, 'C', '0', '0', null,
        'monitor', 'admin', '2021-11-24 14:38:33', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2084, 'HTTP 流量', 2004, 500, 'overview/http', 'protocol/overview/index', 1, 0, 'C', '0', '0', '',
        'international', 'admin', '2021-11-24 15:37:32', 'admin', '2021-11-24 15:37:40', '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2085, '流量数据上传', 2009, 300, 'data-upload', 'configuration/data-upload/index', 1, 0, 'C', '0', '0', '',
        'up-arrow', 'admin', '2022-05-09 13:40:04', 'admin', '2022-05-09 13:43:55', '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2087, '主机', 3, 1, 'host', 'xt/host/index', 1, 0, 'C', '0', '0', 'system:host:list', '#', 'admin',
        '2022-06-23 16:11:41', '', null, '主机菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2088, '主机查询', 2087, 1, '#', '', 1, 0, 'F', '0', '0', 'xt:host:query', '#', 'admin', '2022-06-23 16:11:48',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2089, '主机新增', 2087, 2, '#', '', 1, 0, 'F', '0', '0', 'xt:host:add', '#', 'admin', '2022-06-23 16:11:52', '',
        null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2090, '主机修改', 2087, 3, '#', '', 1, 0, 'F', '0', '0', 'xt:host:edit', '#', 'admin', '2022-06-23 16:11:55',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2091, '主机删除', 2087, 4, '#', '', 1, 0, 'F', '0', '0', 'xt:host:remove', '#', 'admin', '2022-06-23 16:12:00',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2092, '主机导出', 2087, 5, '#', '', 1, 0, 'F', '0', '0', 'xt:host:export', '#', 'admin', '2022-06-23 16:12:03',
        '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2094, '用户信息', 3, 1, 'hostuser', 'xt/hostuser/index', 1, 0, 'C', '0', '0', 'xt:hostuser:list', '#', 'admin',
        '2022-06-23 16:12:43', '', null, '用户信息菜单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2095, '用户信息查询', 2094, 1, '#', '', 1, 0, 'F', '0', '0', 'xt:hostuser:query', '#', 'admin',
        '2022-06-23 16:12:55', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2096, '用户信息查询', 2094, 1, '#', '', 1, 0, 'F', '0', '0', 'xt:hostuser:query', '#', 'admin',
        '2022-06-23 16:12:58', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2097, '用户信息新增', 2094, 2, '#', '', 1, 0, 'F', '0', '0', 'xt:hostuser:add', '#', 'admin',
        '2022-06-23 16:13:01', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2098, '用户信息新增', 2094, 2, '#', '', 1, 0, 'F', '0', '0', 'xt:hostuser:add', '#', 'admin',
        '2022-06-23 16:13:05', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2099, '用户信息修改', 2094, 3, '#', '', 1, 0, 'F', '0', '0', 'xt:hostuser:edit', '#', 'admin',
        '2022-06-23 16:13:08', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2100, '用户信息修改', 2094, 3, '#', '', 1, 0, 'F', '0', '0', 'xt:hostuser:edit', '#', 'admin',
        '2022-06-23 16:13:11', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2101, '用户信息删除', 2094, 4, '#', '', 1, 0, 'F', '0', '0', 'xt:hostuser:remove', '#', 'admin',
        '2022-06-23 16:13:15', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2102, '用户信息删除', 2094, 4, '#', '', 1, 0, 'F', '0', '0', 'xt:hostuser:remove', '#', 'admin',
        '2022-06-23 16:13:18', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2103, '用户信息导出', 2094, 5, '#', '', 1, 0, 'F', '0', '0', 'xt:hostuser:export', '#', 'admin',
        '2022-06-23 16:13:22', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2104, '用户信息导出', 2094, 5, '#', '', 1, 0, 'F', '0', '0', 'xt:hostuser:export', '#', 'admin',
        '2022-06-23 16:13:27', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2105, '资产管理', 0, 400, 'asset-manage', null, 1, 0, 'M', '0', '0', null, 'eye-open', 'admin',
        '2022-06-25 10:57:25', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2106, '资产发现', 2105, 100, 'discover', 'asset-manage/discover/index', 1, 0, 'C', '0', '0', null, 'guide',
        'admin', '2022-06-25 10:58:42', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2107, '历史结果', 2105, 200, 'history', 'asset-manage/history/index', 1, 0, 'C', '0', '0', null, 'list',
        'admin', '2022-06-25 10:59:12', '', null, '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
                                     menu_type, visible, status, perms, icon, create_by, create_time, update_by,
                                     update_time, remark)
VALUES (2108, '资产信息管理', 2105, 300, 'manage', 'asset-manage/manage/index', 1, 0, 'C', '0', '0', null, 'edit',
        'admin', '2022-06-25 11:07:20', '', null, '');


INSERT INTO `sys_role`
VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2021-11-24 13:59:26', '', NULL, '超级管理员'),
       (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2021-11-24 13:59:26', 'admin', '2021-11-24 14:41:39',
        '普通角色');

INSERT INTO `sys_user_post`
VALUES (1, 1);

INSERT INTO `sys_user_role`
VALUES (1, 1),
       (100, 2);

INSERT INTO `sys_user`
VALUES (1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '',
        '$2a$10$cSsNmjlZG90bB07mmhYPweRNF6.Vwi.3R12e6WHtkvWBCl70v/FRa', '0', '0', '117.181.193.83',
        '2022-01-26 14:04:44', 'admin', '2021-11-24 13:59:26', '', '2022-01-26 06:04:43', '管理员'),
       (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '',
        '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '2', '127.0.0.1', '2021-11-24 13:59:26',
        'admin', '2021-11-24 13:59:26', '', NULL, '测试员'),
       (100, NULL, 'etids', 'ETIDS', '00', '', '', '0',
        '/profile/avatar/2021/11/25/bd4c5de3-d00b-4944-a2da-983442e6e3d2.jpeg',
        '$2a$10$DQtQLqcmtCN/7lW4q.Xf/Oadqecu7AJkollfsRrzz2pnIH6Kkbg.q', '0', '0', '223.72.70.39', '2021-12-08 23:58:08',
        'admin', '2021-11-24 14:42:00', 'admin', '2021-12-08 15:58:08', NULL);

UNLOCK TABLES;

DROP TABLE IF EXISTS `xt_metadata`;
CREATE TABLE `xt_metadata`
(
    `uid`          varchar(30) NOT NULL,
    `metadata`     mediumtext,
    `is_encrypted` int(11)     DEFAULT NULL,
    `src_ip`       varchar(30) DEFAULT NULL,
    `dst_ip`       varchar(30) DEFAULT NULL,
    `dst_port`     int(11)     DEFAULT NULL,
    `src_port`     int(11)     DEFAULT NULL,
    `timestamp`    varchar(20) DEFAULT NULL,
    PRIMARY KEY (`uid`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4;

DROP TABLE IF EXISTS `xt_threat`;
CREATE TABLE `xt_threat`
(
    `threat_id`  bigint(20)  NOT NULL AUTO_INCREMENT,
    `name`       varchar(255) DEFAULT NULL,
    `source`     varchar(50)  DEFAULT NULL,
    `hostid`     varchar(11)  DEFAULT NULL,
    `src_ip`     varchar(30)  DEFAULT NULL,
    `dst_ip`     varchar(30)  DEFAULT NULL,
    `src_port`   int(11)      DEFAULT NULL,
    `dst_port`   int(11)      DEFAULT NULL,
    `timestamp`  varchar(40)  DEFAULT NULL,
    `handled`    int(11)      DEFAULT NULL,
    `uid`        varchar(30)  DEFAULT NULL,
    `is_threat`  int(11)     NOT NULL,
    `model_name` varchar(30) NOT NULL,
    PRIMARY KEY (`threat_id`),
    KEY `index_name` (`hostid`),
    KEY `timestampindex` (`timestamp`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 740064
  DEFAULT CHARSET = utf8mb4;

drop table if exists xt_asset_history;
create TABLE xt_asset_history
(
    id        INT    not null auto_increment primary key,
    timestamp BIGINT NOT NULL,
    request   text,
    response  text
) engine = innodb comment = '资产发现历史表';

DROP TABLE IF EXISTS `xt_host`;
CREATE TABLE `xt_host`
(
    `hostid`   varchar(11) NOT NULL COMMENT '主机ID',
    `hostname` varchar(30) DEFAULT NULL,
    `address`  varchar(30) DEFAULT NULL,
    `userId`   varchar(11) DEFAULT NULL COMMENT '主机负责人Id',
    PRIMARY KEY (`hostid`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='主机表';

LOCK TABLES `xt_host` WRITE;
INSERT INTO `xt_host`
VALUES ('7777', 'server-309-vultr', '140.82.10.193', '0001'),
       ('7778', 'server-309-aliyun', '208.167.248.218', '0000'),
       ('7979', 'server-309-digitalocean', '45.63.21.151 ', '0000');
UNLOCK TABLES;

DROP TABLE IF EXISTS `xt_hostuser`;
CREATE TABLE `xt_hostuser`
(
    `user_id`     varchar(11) NOT NULL COMMENT '用户编号',
    `name`        varchar(11) DEFAULT '' COMMENT '用户名',
    `phone`       varchar(13) DEFAULT '' COMMENT '联系方式',
    `departure`   varchar(20) DEFAULT '' COMMENT '部门',
    `job`         varchar(20) DEFAULT '' COMMENT '职位',
    `description` varchar(20) DEFAULT '' COMMENT '备注',
    PRIMARY KEY (`user_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='用户信息表';

LOCK TABLES `xt_hostuser` WRITE;
INSERT INTO `xt_hostuser`
VALUES ('0000', 'Eniac', '11122233456', 'Development', 'qa', '这是一个测试用户'),
       ('0001', 'Zhangzhao', '12341234545', 'Research', 'qa', '');
UNLOCK TABLES;

DROP TABLE IF EXISTS `xt_sensor`;
CREATE TABLE `xt_sensor`
(
    `sensor_id`   bigint(20) NOT NULL AUTO_INCREMENT,
    `type`        varchar(20) DEFAULT NULL,
    `hostid`      varchar(11) DEFAULT NULL,
    `sensor_name` varchar(30) DEFAULT NULL,
    PRIMARY KEY (`sensor_id`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 3
  DEFAULT CHARSET = utf8mb4;

LOCK TABLES `xt_sensor` WRITE;
INSERT INTO `xt_sensor`
VALUES (1, 'suricata', '7777', 'suricata-1'),
       (2, 'zeek', '7777', 'zeek-1');
UNLOCK TABLES;

