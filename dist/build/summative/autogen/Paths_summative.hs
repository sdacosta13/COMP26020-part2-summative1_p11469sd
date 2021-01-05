{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_summative (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/sam/.cabal/bin"
libdir     = "/home/sam/.cabal/lib/x86_64-linux-ghc-8.6.5/summative-0.1.0.0-3dhI9IiZ9okGrsg5afy4K7"
dynlibdir  = "/home/sam/.cabal/lib/x86_64-linux-ghc-8.6.5"
datadir    = "/home/sam/.cabal/share/x86_64-linux-ghc-8.6.5/summative-0.1.0.0"
libexecdir = "/home/sam/.cabal/libexec/x86_64-linux-ghc-8.6.5/summative-0.1.0.0"
sysconfdir = "/home/sam/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "summative_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "summative_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "summative_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "summative_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "summative_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "summative_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
