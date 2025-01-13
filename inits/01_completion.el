;;; -*- lexical-binding: t -*-

;;; vertico
;; Package `vertico' is an incremental completion and narrowing
;; framework. Like Ivy and Helm, which it improves on, Vertico
;; provides a user interface for choosing from a list of options by
;; typing a query to narrow the list, and then selecting one of the
;; remaining candidates. This offers a significant improvement over
;; the default Emacs interface for candidate selection.  It might be
;; worthwhile to look and adapt things from here:
;; https://github.com/radian-software/radian/blob/develop/emacs/radian.el#L1007"
(require 'vertico)

(setq vertico-cycle t     ; Enable vertico-next/previous cycling
      vertico-resize nil  ; How to resize the Vertico minibuffer window.
      vertico-count 8     ; Maximal number of candidates to show.
      vertico-count-format nil) ; No prefix with number of entries

(vertico-mode)
(vertico-mouse-mode +1)  ;; Enable mouse support for clicking on candidates.

;;; orderless
;; This package provides an `orderless' completion style that matches
;; all the component at any order"
;; "https://github.com/oantolin/orderless"
(setq completion-styles '(orderless basic)
      completion-category-overrides '((file (styles basic partial-completion))))


;;; marginalia
;; This package provides marginals in minibuffer that is helpful
(require 'marginalia)

(setq-default marginalia--ellipsis "…"    ; Nicer ellipsis
              marginalia-align 'center)   ; Center alignment


(marginalia-mode)
