;;; -*- lexical-binding: t -*-

(setq package-list
      '(orderless           ; Completion style for matching regexps in any order
        vertico             ; VERTical Interactive COmpletion
	marginalia          ; Enrich existing commands with completion annotations
	))

(setq desktop-only-package-list
      (append package-list
	      '(ellama      ; language model tool
		magit       ; git client
		)))

(when is-android
  (dolist (package package-list)
    (unless (package-installed-p package)
      (package-install package))))

(when (not is-android)

  (straight-use-package '(org :type built-in))

  (dolist (package desktop-only-package-list)
    (straight-use-package package)))
