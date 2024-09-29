#!/usr/bin/env nix-shell
#!nix-shell -i runghc -p "haskellPackages.ghcWithPackages (pkgs: [ pkgs.turtle pkgs.neat-interpolation])"
--nix-shell --pure -i runghc -p "haskellPackages.ghcWithPackages (pkgs: [ pkgs.turtle, pkgs.NeatInterpolation ])"

{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}

import Turtle hiding (text)
import NeatInterpolation (text)

-- The path og the NixOS build that we're depoying
newtype NixOS = NixOS Text
newtype Server = Server Text 

main :: IO ()
main = sh $ do
  server <- getServer
  path <- build
  --show path
  --echo (lineToText server)
  upload server path
  activate server path

getServer :: Shell Server
getServer = do
    line <- single $ input "server-address.txt"
    return $ Server (lineToText line)


build :: Shell NixOS
build = do
    line <- single $
        inproc "nix-build" ["server.nix", "--no-out-link"] empty
    return $ NixOS (lineToText line)

upload :: Server -> NixOS -> Shell ()
upload (Server server) (NixOS path) =
    procs command args empty
    where
       command = "nix-copy-closure"
       --command = "echo"
       args = ["--to", "--use-substitutes", server, path]

activate :: Server -> NixOS -> Shell ()
activate (Server server) (NixOS path) =
    procs command args empty
    where
       command = "ssh"
       args = [server, remoteCommand]
       remoteCommand = [text|
           nix-env --profile $profile --set $path
	   $profile/bin/switch-to-configuration switch
	   |]
       profile = "/nix/var/nix/profiles/system"
