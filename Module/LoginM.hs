{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

{-# LANGUAGE MultiParamTypeClasses #-}
module Module.LoginM where

import Foundation

import  Control.Applicative ((<$>), (<*>))
import  Yesod
import  Yesod.Form.Jquery

import Data.Text (Text,pack)
import Settings

import Data.Text.Encoding(decodeUtf8)
import Yesod.Core.Handler
import Network.Wai
import Data.Text as DT

{-用于生成需要提交的登录表单内容，并填充对应的项-}

data LoginMessage = LoginMessage{ name :: Text
                                , password :: Text
                                , currentUrl :: Text
                                , sex::Text
                                , hobby::[Text]
                                , cars::[Text]
                                } deriving Show
data LogoutMessage = LogoutMessage deriving Show


getCurrentUrl :: MonadHandler m => m Text
getCurrentUrl = do
    req <- waiRequest
    current_route <- getCurrentRoute >>= maybe (error "getCurrentRoute failed") return
    url_render <- getUrlRender
    return $ url_render current_route  `mappend` decodeUtf8 (rawQueryString req)


loginForm :: Html -> MForm Handler (FormResult LoginMessage, Widget)
loginForm extra = do
            url <- getCurrentUrl
            flip renderDivs extra $ LoginMessage
                <$> areq textField "用户名" Nothing
                <*> areq passwordField "密码" Nothing
                <*> areq hiddenField "" (Just url)
                <*> areq (radioFieldList [(DT.pack "1", DT.pack "男"),(DT.pack "2", DT.pack "女")]) "性别" Nothing
                <*> areq (checkboxesField $ optionsPairs hobby) "兴趣" Nothing
                <*> areq (multiSelectField $ optionsPairs [(DT.pack "宝马", DT.pack "宝马"),(DT.pack "大众", DT.pack "大众")]) "坐驾" Nothing  -- 下拉选中
             where hobby = Prelude.map (\(x,y)->(DT.pack x , DT.pack y)) [("音乐","音乐"),("体育","体育")]
logoutForm :: Html -> MForm Handler (FormResult LogoutMessage, Widget)
logoutForm = renderDivs $ pure LogoutMessage



--logoutForm = renderDivs $ LogoutMessage
--                 <$> areq textField "当前页面" Nothing
