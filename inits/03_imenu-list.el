;;; 03_imenu-list.el ---  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(use-package imenu-list :ensure t
  ;; Show the current buffer's imenu entries in a seperate buffer
  ;; https://github.com/Ladicle/imenu-list
  :straight '(imenu-list
              :type git
              :host github
              :repo "Ladicle/imenu-list"))

  :bind (([f10] . imenu-list-smart-toggle))

  :hook ((imenu-list-major-mode-hook . neo-hide-nano-header))
  
  :custom
  (imenu-list-auto-resize  t)
  (imenu-list-focus-after-activation  t)
  (imenu-list-entry-prefix   "•")
  (imenu-list-subtree-prefix  "•")

:custom-face
  (imenu-list-entry-face-1          . '((t (:foreground "white"))))
  (imenu-list-entry-subalist-face-0 . '((nil (:weight normal))))
  (imenu-list-entry-subalist-face-1 . '((nil (:weight normal))))
  (imenu-list-entry-subalist-face-2 . '((nil (:weight normal))))
  (imenu-list-entry-subalist-face-3 . '((nil (:weight normal)))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 03_imenu-list.el ends here
