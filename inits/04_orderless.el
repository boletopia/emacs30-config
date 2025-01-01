;;; 04_orderless.el --- Org mode configurations. -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(use-package orderless  :ensure t
  ;; This package provides an `orderless' completion style that
  ;; matches all the component at any order
  ;; https://github.com/oantolin/orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 04_orderless ends here
