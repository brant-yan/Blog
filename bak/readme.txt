问：如何将简单的数据渲染到页面上
答：在defaultLayout后面，可以简单的用where带上你需要的data结构，这样可以在[||]中使用函数和data来渲染你需要的值
[whamlet||]可以任意堆叠，但是只能带一个where。这符合haskell的标准语法
有因为do是haskell的标准语法，所以可以在do内使用monad来提取你需要数据（一般数据用return或者pure来包装）
例如可以通过文件句柄来提取类似本地图片或者配置文件之类的东西.

例：
getHomeR = defaultLayout $ do
    man <- return $ Person "Jack" 47
    setTitle "Minimal Multifile"
    [whamlet|
        <p>
            <a href=@{AddR 5 7}>HTML addition
        <p>
            <a href=@{AddR 5 7}?_accept=application/json>JSON addition
        <p>
            <a href=@{HelpR}>Help Page
        <b> #{name person} is  #{age person} old


    |]
    [whamlet|
        #{name man} is  #{age man} old
    |]
    where
        person = Person "brant" 123

问：hamlet,whamlet,shamlet有什么区别
答：whamlet表示可以包括Html，Css，Js的统一的hamlet，
shamlet是simple hamlet的简写。目前来说，当页面结构足够简单的时候，可以使用shamlet
shamlet和hamlet都可以使用toWidget来转为whamlet.转换成whamlet之后就可以使用do结构了

例：
getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    man <- pure $ Person "Jack" 47
    setTitle "Minimal Multifile"
    [whamlet|
        #{name man} is  #{age man} old

    |]
    toWidget [shamlet|
        <p>
            <strong>This is shamlet message  #{name person}
    |]
    toWidget [hamlet|
            <p>
                <strong>This is hamlet message #{name person}
        |]
    where
        myself = Just $ Person "myself" 456
        person = Person "brant" 123
        person1 = Person "father" 56
        person2 = Person "mother" 54
        people = [person1,person2]

问：是否有其他函数来直接在whamlet的堆叠中插入字符串或者变量
答：可以使用的有如下
addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"
toWidgetHead [hamlet| <meta name=keywords content="some sample keywords">|]
toWidgetBody [julius| alert("This is included in the body itself"); |]
addCassiusMedia, addLuciusMedia
addStylesheet
addStylesheetRemote
addScript
addScriptRemote

问：widget到底是什么
答：The job of a widget is to hold onto these disparate components and
apply proper logic for combining different widgets together.
This consists of things like taking the first title set and ignoring others,
filtering duplicates from the list of external scripts and stylesheets,
and concatenating head and body content.

问：怎么搞一个随机值
答：在do中，使用 tempValue <- newIdent 来生成一个编译范围内的随机值。
注意这个随机值并不是运行时随机值，也就是在编译时值是随机的，运行时是确定的

问：如何考虑堆叠业务
答：把业务用hamlet,lucius等转成Q,然后再用toWidget转成[whamlet|..|]
最后在do中把这些堆叠起来

问：如何写自己的业务
答：业务就是一个普通的函数，只是最后的类型是Widget
当然用[hamlet||]和[shamlet||]也可以。只是我现在还不会
例子：
getHelpR :: Int -> Handler Html
getHelpR  myp = defaultLayout $ do
                [whamlet|This is Help Page #{myp}|]
                myNewHelp 4444

myNewHelp :: Int -> Widget
myNewHelp n = [whamlet| You give me #{n}|]

问：hamlet中的常用标签
答：  @{..} URL
     #{..} 变量
     ^{..} embed 需要注意，当使用^{..}标签时，embed进来的hamlet需要和容器是一个类型，通过toWidget来转换类型是不行的
例:
   foot = [whamlet|^{page}|]
   page = [whamlet|123|]
或者
    foot =[hamlet|^{page}|]
    page =[hamlet|123|]

RepHtml is a data type containing some raw HTML output ready to be sent over the wire

问：如何更换基础模板
答：重新定义defaultLayout

问：如何更换基础域名：
答：重载approot
例子
instance Yesod MyWiki where
    approot = ApprootStatic "http://static.example.com/wiki"

问：如何从配置文件载入Route
答：使用
mkYesodData "App" $(parseRoutesFile "config/routes")


问：如何提取request参数
答：可以使用lookupGetParam，lookupCookie，languages来操作，如果是post需要先运行一下runRequest
例子：
    http://localhost:3000/?style=aaaa&param=123
    getHomeR :: Handler Html
    getHomeR = defaultLayout $ do
        req <- getRequest
        let params = reqGetParams req
        paramStyle <- lookupGetParams "style"
        ...
        [whamlet|
            #{head paramStyle} -- 需要注意有可能 head paramStyle不存在
            #{show params} --可以将params转成map再来查找

问：如何重定向
答：首先在route里面定义好原本的业务。然后在代码里面用redirect或者redirectWith来重定向
例子：
    getRedirectR :: Handler Html
    getRedirectR = redirect HelpR
1.可以在URL按照REST方式携带参数
1.1 redirect $ HelpR {param}
1.2 HelpR:: Handler Html 变形为 HelpR :: Int -> Handler Html
1.3 修改Route  /help HelpR GET 变形为 /help/#Int HelpR GET
1.4 可以用的参数有Int和Text类型。注意Text可以通过Data.Text.pack [Char]来生成，而且在url中会被encode掉。

2.在param中携带新参数？？


问：如何组合各种页面
答：如果拿到[whamlet||]，可以借用monad，用do来组合多个[whamlet||]

问: 如何直接在页面上输出变量
答：当采用变量是，建议使用#{show param}来输出内容

问：如果用模板
答：1.安装hledger-web库并加入到.cabal文件中(可以cabal install hledger或者stack install hledger)
    安装完毕之后，cabal的需要修改.cabal,stack的需要修改
    stack.yaml
    extra-deps: [hledger-web-1.0.1,wai-handler-launch-3.0.2.1]
  2.import Settings
  3.在src的同级建立目录templates
  4.在templates中增加一个文件，例如homepage.hamlet
  5.需要在代码中开启{-# LANGUAGE TemplateHaskell #-}

使用文件作为渲染器
getHomeR :: Handler RepHtml
getHomeR = myLayout $ do
          $(widgetFile "echo")
          $(widgetFile "echo")
使用文件作为模板器

myLayout :: Widget -> Handler Html
myLayout widget = do
    pc <- widgetToPageContent widget
    giveUrlRenderer $( hamletFile "templates/my-layout.hamlet")

my-layout.hamlet

$doctype 5
<html>
    <head>
    <body>
        <h1>This is my template start
        ^{pageBody pc}
        <h1>
            This is my template end

问：如何获取时间
答：可以采用如下两种方法
import Data.Time (getCurrentTime)
now <- liftIO getCurrentTime


import Data.UnixTime
ut <-  liftIO $ getUnixTime
let t = formatUnixTimeGMT webDateFormat ut

问：如何从数据库中通过ID获取对象
import Database.Persist.Types (PersistValue(PersistInt64))

getByIntId :: Integral i => i -> Handler (Maybe Person)
getByIntId i = runDB $ get $ Key $ PersistInt64 (fromIntegral i)