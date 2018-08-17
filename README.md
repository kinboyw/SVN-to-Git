# 从SVN迁移到Git的一些资料
 《从SVN到Git》 是这个项目最初的主体内容，后来将逐渐扩充了其他方面的内容。

## 目录
- [从SVN到Git](doc/从SVN到Git.md) 
- [签出正式开发代码，修改，提交](doc/签出正式开发代码，修改，提交.md) 
- [Git 基础](doc/Git 基础.md) 
- [常用命令行](doc/常用命令行.md) 
- [让Git支持Windows Symbolic link](doc/让Git支持Windows Symbolic link.md) 
- [Nginx 配置文件nginx.conf中文详解](doc/Nginx 配置文件nginx.conf中文详解.md) 
- [关于12.1服务器的配置](doc/关于12.1服务器的配置.md) 
- [关于ConfCenter和Web4移出服务代码的更新](doc/对于ConfCenter和Web4移出服务代码的更新.md) 
- [Git 使用Http(s)协议同步时修改验证](doc/Git 使用Http(s)协议同步时修改验证.md)


## Markdown
Markdown 是一种轻量级纯文本格式语法的修饰语言，可以轻松转换成 HTML 和其他很多种格式。Markdown常用于格式化 readme 文件，在网络论坛中编辑消息，以及使用纯文本编辑器创建富文本内容。由于Markdown的初步描述包含含糊不清和未解答的问题，所以多年来，Markdown出现了许多实现和扩展来回答这些问题
> From Wikipedia, the free encyclopedia
>
> Jump to navigation
>
> Jump to search
>
> For the marketing term, see [Price markdown](https://en.wikipedia.org/wiki/Price_markdown).
>
> | [![Markdown-mark.svg](https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Markdown-mark.svg/64px-Markdown-mark.svg.png)](https://en.wikipedia.org/wiki/File:Markdown-mark.svg) |                                                              |
> | ------------------------------------------------------------ | ------------------------------------------------------------ |
> | [Internet media type](https://en.wikipedia.org/wiki/Media_type) | `text/markdown`[[1\]](https://en.wikipedia.org/wiki/Markdown#cite_note-rfc7763-1) |
> | [Uniform Type Identifier (UTI)](https://en.wikipedia.org/wiki/Uniform_Type_Identifier) | `net.daringfireball.markdown`                                |
> | Developed by                                                 | [John Gruber](https://en.wikipedia.org/wiki/John_Gruber)     |
> | Initial release                                              | March 19, 2004 (14 years ago)[[2\]](https://en.wikipedia.org/wiki/Markdown#cite_note-markdown-swartz-2)[[3\]](https://en.wikipedia.org/wiki/Markdown#cite_note-gruber-2004-release-3) |
> | [Latest release](https://en.wikipedia.org/wiki/Software_release_life_cycle) | 1.0.1 (December 17, 2004 (13 years ago)[[4\]](https://en.wikipedia.org/wiki/Markdown#cite_note-md-4)) |
> | Type of format                                               | [Markup language](https://en.wikipedia.org/wiki/Markup_language) |
> | Extended to                                                  | [MultiMarkdown](https://en.wikipedia.org/wiki/MultiMarkdown), [Markdown Extra](https://en.wikipedia.org/wiki/Markdown_Extra), [CommonMark](https://en.wikipedia.org/wiki/CommonMark)[[5\]](https://en.wikipedia.org/wiki/Markdown#cite_note-rfc7764-5) |
> | [Open format](https://en.wikipedia.org/wiki/Open_format)?    | yes[[6\]](https://en.wikipedia.org/wiki/Markdown#cite_note-license-6) |
> | Website                                                      | [daringfireball.net/projects/markdown](https://daringfireball.net/projects/markdown) |
>
> **Markdown** is a [lightweight markup language](https://en.wikipedia.org/wiki/Lightweight_markup_language) with plain text formatting syntax. It is designed so that it can be converted to [HTML](https://en.wikipedia.org/wiki/HTML) and many other formats using a tool by the same name.[[8\]](https://en.wikipedia.org/wiki/Markdown#cite_note-8)Markdown is often used to format [readme files](https://en.wikipedia.org/wiki/README), for writing messages in online discussion forums, and to create [rich text](https://en.wikipedia.org/wiki/Formatted_text) using a [plain text](https://en.wikipedia.org/wiki/Plain_text) [editor](https://en.wikipedia.org/wiki/Text_editor). As the initial description of Markdown contained ambiguities and unanswered questions, many implementations and extensions of Markdown appeared over the years to answer these issues.

 我在`工具` 文件夹里面提供了`markdown viewer.crx` 这个Chrome浏览器插件，安装后可以直接在Chrome浏览器中查看MardDown文档

 安装好以后需要在扩展设置中打开这个插件的`允许读取文件路径`的 选项，不然浏览器只能打开网络上的MarkDown文件当，无法打开本地文件
