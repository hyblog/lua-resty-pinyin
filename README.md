Name
====

lua-resty-pinyin

Description
===========

这是一个ngx_lua小程序,它可以将字符串中的汉字转换为拼音!

Test
========

```lua
    lua_package_path '/path/to/resty/?.lua;;';

    server {
        location /test {
            content_by_lua '
                local pinyin = require "resty.pinyin"
                local str = "这是一个ngx_lua小程序,它可以将字符串中的汉字转换为拼音!"
                local to_py, err = pinyin.convert(str)

                -- output
                -- zheshiyigengx_luaxiaochengxu,takeyijiangzifuchuanzhongdehanzizhuanhuanweipinyin!

                ngx.print(to_py)
            ';
        }
    }
```

[Back to TOC](#table-of-contents)