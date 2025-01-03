;; -*- lexical-binding: t -*-

(when is-android (eval-and-compile
		   (customize-set-variable
		    'package-archives '(("melpa" . "https://melpa.org/packages/")))
		   (package-initialize)
		   (unless (package-installed-p 'use-package)
		     (package-refresh-contents)
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

(provide 'package-manager)
