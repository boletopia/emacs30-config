;;; -*- lexical-binding: t -*-

(setq package-list
      '(orderless           ; Completion style for matching regexps in any order
        vertico             ; VERTical Interactive COmpletion
	marginalia          ; Enrich existing commands with completion annotations
	))


(when is-android
  (dolist (package package-list)
    (unless (package-installed-p package)
      (package-install package))))


(setq desktop-only-package-list
      (append package-list
	      '(ellama      ; language model tool
		magit       ; git client
		)))

(when (not is-android)

  (straight-use-package '(org :type built-in))

  (straight-use-package
   '(whisper :type git :host github :repo "natrys/whisper.el"))
  
  (dolist (package desktop-only-package-list)
    (straight-use-package package)))
