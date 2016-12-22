{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Snippet.BlogS where

import Handler.Import
import Module.BlogM



{-
1.提供渲染blogWidget的逻辑
-}

newBlogWidget :: Widget
newBlogWidget = do
        (widget, enctype) <- handlerToWidget $ generateFormPost blogForm
        $(widgetFile "widget/blog_a_write")


blogsWidget :: Widget
blogsWidget = do
             bloglist <- handlerToWidget $ runDB $ selectList [] [LimitTo 3,Desc BlogId]
             $(widgetFile "widget/blogs_v")


blogWidget :: BlogId ->  Widget
blogWidget bid = do
             bloglist <- handlerToWidget $ runDB $ selectList [BlogId ==. bid] []
             $(widgetFile "widget/blog_v")

blogListWidget :: Int ->  Widget
blogListWidget bindex = do
             bloglist <- handlerToWidget $ runDB $ selectList [] [LimitTo 3, OffsetBy (bindex * 3),Desc BlogId]
             $(widgetFile "widget/blog_v")

