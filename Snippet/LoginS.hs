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




module Snippet.LoginS where


import Data.Text as DT
import Data.Text.Encoding (encodeUtf8)
import Yesod.Core.Handler(toTextUrl)

import Handler.Import
import Module.LoginM


{-
1.提供渲染loginWidget的逻辑
-}
loginSnippet :: Maybe Text -> Widget
loginSnippet mt = case mt of
        Nothing   -> do
                   (widget, enctype) <- handlerToWidget $ generateFormPost loginForm
                   people <- handlerToWidget $ runDB $ selectList [] [LimitTo 1]
                   let persons = people::[Entity Person]
                   $(widgetFile "widget/login_a")
        Just name -> do
                   (widget, enctype) <- handlerToWidget $ generateFormPost logoutForm
                   head_img <- return ("/static/img/phoenix.jpg"::Text)
                   $(widgetFile "widget/userInfo_v")
                   $(widgetFile "widget/logout_a")