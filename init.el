;;; init.el --- Emacs first Configuration. -*- lexical-binding: t -*-
;;; Commentary:
;;
;;; Code:
;; (setq debug-on-error t)

(when (version< emacs-version "30")
  (error "This requires Emacs 30 and above!"))

;; Add user directory "elisp" to load-path
(push (expand-file-name "elisp/" user-emacs-directory) load-path)
(push (expand-file-name "inits/" user-emacs-directory) load-path)


;;  Auto compile
(defun auto-compile-inits ()
  "Byte compile Lisp files modified in the directory."
  (interactive)
  (byte-recompile-directory (expand-file-name "elisp" user-emacs-directory) 0)
  (byte-recompile-directory (expand-file-name "inits" user-emacs-directory) 0))
(add-hook 'kill-emacs-hook 'auto-compile-inits)


;; detect if we can run gui
(defconst is-gui (eq window-system 'x))


;; Faster to disable these here (before they've been initialized)
(when is-gui
  (push '(fullscreen . maximized) default-frame-alist))


;; Set transparency for gui
(when is-gui
  (push '(alpha . (90 . 90)) default-frame-alist))


;; initialize package.el
(require 'package)
(package-initialize)

;; Add package archives
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)


;; Ensure use-pacakge is installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


;; Bootstrap straight.el
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
  (load bootstrap-file nil 'nomessage))

;; Init loader
(use-package init-loader :ensure t
  :straight '(init-loaderc
              :type git
              :host github
              :repo "emacs-jp/init-loader")
  :config
  (custom-set-variables
   '(init-loader-show-log-after-init 'error-only))
  (init-loader-load)
  (setq custom-file (locate-user-emacs-file (expand-file-name "tmp/custom.el" user-emacs-directory))))


(provide 'init)

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; init.el ends here
