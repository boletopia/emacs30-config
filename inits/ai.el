;;  -*- lexical-binding: t -*-

;; ellama
;; https://github.com/s-kostyaev/ellama
;; provide methods interacting with llms

(require 'ellama)
(require 'llm-ollama)
(setopt ellama-provider
        (make-llm-ollama
         ;; this model should be pulled to use it
         ;; value should be the same as you print in terminal during pull
         :chat-model "llama3.2"
         :embedding-model "nomic-embed-text"))
