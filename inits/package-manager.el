;; -*- lexical-binding: t -*-

(when is-android (eval-and-compile
		   (customize-set-variable
		    'package-archives '(("melpa" . "https://melpa.org/packages/")
					("gnu" . "https://elpa.gnu.org/packages/")))
		   (package-initialize)
		   (unless package-archive-contents
		     (package-refresh-contents))
		   (unless (package-installed-p 'use-package)
		     (package-install 'use-package))
		   (require 'use-package)))

(when (not is-android)
  (defvar bootstrap-version)
  (let ((bootstrap-file
	 (expand-file-name
          "straight/repos/straight.el/bootstrap.el"
          (or (bound-and-true-p straight-base-dir)
              user-emacs-directory)))
	(bootstrap-version 7))
    (unless (file-exists-p bootstrap-file)
      (with-current-buffer
          (url-retrieve-synchronously
           "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
           'silent 'inhibit-cookies)
	(goto-char (point-max))
	(eval-print-last-sexp)))
    (load bootstrap-file nil 'nomessage)))


(when is-android
  (unless (package-installed-p init-loader)
    (package-install init-loader)))

(when (not is-android)
  (require 'straight)
  (straight-use-package
   '(init-loader :type git :host github :repo "emacs-jp/init-loader")))
