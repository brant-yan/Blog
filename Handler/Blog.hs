{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Blog where

import Handler.Import
import Module.BlogM
import Data.Text as DT
import Orm



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

{-
2.提供相对于blog的业务页面
-}
getWriteBlogR::Handler Html
getWriteBlogR = homepageDashboard $ do
             let content=newBlogWidget
             $(widgetFile "frame/center")


getReadBlogR :: BlogId ->  Handler Html
getReadBlogR blogId = homepageDashboard $ do
                     let content=blogWidget blogId
                     $(widgetFile "frame/center")

postRecordBlogR::Handler Html
postRecordBlogR = do
            ((blogMessage , _),_) <- runFormPost blogForm
            case blogMessage of
                FormSuccess message -> do
                                Just name <- lookupCookie "login-name"
                                people <-  runDB $ selectList [PersonName ==. (DT.unpack name)] [LimitTo 1]
                                let persons = people::[Entity Person]
                                blogId <- runDB $ insert $ pid2blog (entityKey $ (Prelude.head) persons)
                                setMessage "文章保存成功"
                                redirect HomeR
                                    where
                                        pid2blog  :: PersonId -> Blog
                                        pid2blog pid = Blog pid (DT.unpack (title message)) (DT.unpack (content message)) (DT.unpack (createTime message))
                _ -> do
                    setMessage "文章保存失败"
                    redirect HomeR
