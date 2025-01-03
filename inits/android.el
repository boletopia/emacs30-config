;;; -*- lexical-binding: t -*-
(when is-android

  ;; Add termux binaries
  ;; https://marek-g.github.io/posts/tips_and_tricks/emacs_on_android/
  (setenv "PATH" (format "%s:%s" "/data/data/com.termux/files/usr/bin"
			 (getenv "PATH")))
  (setenv "LD_LIBRARY_PATH" (format "%s:%s"
				    "/data/data/com.termux/files/usr/lib"
				    (getenv "LD_LIBRARY_PATH")))
  (push "/data/data/com.termux/files/usr/bin" exec-path)


  ;; provide gnutls since android emacs isn't compiled with one
  (setq tls-program '("gnutls-cli -p %p %h"
		      "gnutls-cli -p %p %h --protocols ssl3"))


  ;; Add modifier key bar
  ;; after init
  (require 'tool-bar)
  (add-hook 'after-init-hook
            (lambda ()
              (tool-bar-mode 1)
              (menu-bar-mode 1)
              (set-frame-parameter nil 'tool-bar-position 'bottom)
              (modifier-bar-mode 1))))
