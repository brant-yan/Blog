{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Snippet.RegisterS where

import Data.Text.Encoding (encodeUtf8)
import Yesod.Core.Handler(toTextUrl)

import Handler.Import
import Module.RegisterM


registerWidget :: Widget
registerWidget  = do
            (widget, enctype) <- handlerToWidget $ generateFormPost registerForm
            $(widgetFile "widget/register")