;;; -*- lexical-binding: t -*-
;; @see https://github.com/progfolio/elpaca#installer

(custom-set-variables
 '(package-enable-at-startup nil))

;; Log native-compilation warnings from third-party packages to *Warnings*
;; without popping up the buffer.
(setq native-comp-async-report-warnings-errors 'silent)
