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

import Application () -- for YesodDispatch instance
import Foundation
import Yesod.Core
import Yesod.Static
import Yesod.Persist
import Database.Persist.Sqlite
import Control.Monad.Trans.Resource (runResourceT)
import Control.Monad.Logger (runStderrLoggingT)

import Orm.PersonD

--main = do
--   persons <- (runDb $ selectList [] [LimitTo 10])
--   mapM (print) persons

openConnectionCount :: Int
openConnectionCount = 10

main :: IO ()
main = runStderrLoggingT $ withSqlitePool "dev.sqlite3" openConnectionCount
        $ \pool -> liftIO $ do
        runResourceT $ flip runSqlPool pool $ do
            runMigration migrateAll
        s@(Static settings) <- static "static"
        warp 3000 $ App s pool


--main :: IO ()
--main = do
--    let config = SqliteConf "dev.sqlite3" 1
--    pool <- createPoolConfig config
--    s@(Static settings) <- static "static"
--    warp 3000 $ App s config pool
