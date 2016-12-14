{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Blog where

import Handler.Import
import Module.BlogM


{-
1.提供渲染blogWidget的逻辑
-}

blogWidget :: Widget
blogWidget = do
        (widget, enctype) <- handlerToWidget $ generateFormPost blogForm
        $(widgetFile "widget/blog")
blogsWidget ::Widget
blogsWidget = do
             let blogs = getBlogs 10
             $(widgetFile "widget/blogs")
