{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ViewPatterns #-}

module Handler.Register where



import Data.Text as DT
import Data.Text.Encoding (encodeUtf8)
import Yesod.Core.Handler(toTextUrl)

import Handler.Import
import Module.RegisterM
import Snippet.RegisterS


getRegisterR :: Handler Html
getRegisterR = homepageDashboard $ do
           let content=registerWidget
           $(widgetFile "frame/center")


postRegisterR :: Handler Html
postRegisterR = do
            ((resultLogin , _),_) <- runFormPost registerForm
            case resultLogin of
                FormSuccess message -> do
                     maybePerson <- runDB $ selectList [PersonName ==. (DT.unpack (name message))] []
                     case Prelude.length maybePerson of
                        0 -> do
                             peopleId <- runDB $ insert $ Person (DT.unpack (name message)) (DT.unpack (password message)) ("123"::String)
                             setMessage "注册成功"
                             redirect HomeR
                        _ -> do
                            setMessage "用户已存在"
                            redirect RegisterR


                _ -> do
                     setMessage "注册失败"
                     redirect HomeR


