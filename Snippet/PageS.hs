{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Snippet.PageS where

import Handler.Import

pageWidget ::Int ->   Widget
pageWidget pIndex = do
                 let pagelast = pIndex
                 let pagenext = pIndex - 2
                 $(widgetFile "widget/page")