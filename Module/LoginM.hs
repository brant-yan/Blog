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
logoutForm :: Html -> MForm Handler (FormResult LogoutMessage, Widget)
logoutForm = renderDivs $ pure LogoutMessage



--logoutForm = renderDivs $ LogoutMessage
--                 <$> areq textField "当前页面" Nothing
