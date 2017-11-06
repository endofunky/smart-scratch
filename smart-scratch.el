;;; smart-scratch.el --- Smart major mode scratch buffers

;; Copyright (C) 2017 Tobias Svensson <tob@tobiassvensson.co.uk>

;; Author: Tobias Svensson <tob@tobiassvensson.co.uk>
;; URL: https://github.com/endofunky/smart-scratch
;; Version: 1.0.0
;; Keywords: editing
;; Package-Requires: ((cl-lib "0.5"))

;; This file is NOT part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING. If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; See the README for more info:
;; https://github.com/endofunky/smart-scratch

;;; Code:

(require 'cl-lib)

(defgroup smart-scratch nil
  "major-mode-specific scratch buffer tools."
  :prefix "smart-scratch-"
  :group 'editing)

(defcustom smart-scratch-buffer-prefix "scratch-"
  "Scratch buffer name prefix"
  :type '(string)
  :group 'diff)

(defcustom smart-scratch-buffer-suffix ""
  "Scratch buffer name suffix"
  :type '(string)
  :group 'diff)

(defvar smart-scratch--modes
  '((emacs-lisp-mode . lisp-interaction-mode)
    (inferior-emacs-lisp-mode . lisp-interaction-mode)
    (inf-ruby-mode . ruby-mode)))

(defvar smart-scratch--prev-buffers (make-hash-table :weakness 'value))

(defun smart-scratch--major-mode (&optional buffer)
  "Returns the major mode for the given buffer or the current buffer."
  (let ((mode (buffer-local-value 'major-mode (if buffer
                                                  buffer
                                                (current-buffer)))))
    (or (cdr (assoc mode smart-scratch--modes))
        mode)))

(defun smart-scratch--initial-mm-p ()
  "Returns t if the main scratch buffer corresponds to the current major-mode."
  (if-let* ((scratch-buffer (get-buffer "*scratch*")))
      (and (eq initial-major-mode (smart-scratch--major-mode))
           (eq initial-major-mode (smart-scratch--major-mode
                                   scratch-buffer)))))

(defun smart-scratch--special-buffer-p ()
  "Returns t if the current buffer is derived from special-mode"
  (or (derived-mode-p 'special-mode)
      (derived-mode-p 'dired-mode)))

(defun smart-scratch--major-mode-name ()
  "Returns the name of the major mode for the current buffer."
  (format "%s" (smart-scratch--major-mode)))

(defun smart-scratch--name ()
  "Returns the scratch buffer name for the current major-mode."
  (if (smart-scratch--initial-mm-p)
      "*scratch*"
    (let ((name (replace-regexp-in-string "-mode\\'" ""
                                          (smart-scratch--major-mode-name))))
      (concat "*"
              smart-scratch-buffer-prefix
              name
              smart-scratch-buffer-suffix
              "*"))))

(defun smart-scratch--switch-to ()
  "Switches to the scratch buffer for the given major mode."
  (let ((buffer (get-buffer-create (smart-scratch--name)))
        (mode-str (smart-scratch--major-mode-name)))
    (puthash mode-str (current-buffer) smart-scratch--prev-buffers)
    (switch-to-buffer buffer)
    (funcall (intern mode-str))))

(defun smart-scratch--switch-back ()
  "Switches back to the previous buffer for the current scratch buffer's
major mode."
  (let* ((mode-str (smart-scratch--major-mode-name))
         (prev-buffer (gethash mode-str smart-scratch--prev-buffers)))
    (if (buffer-live-p prev-buffer)
        (switch-to-buffer prev-buffer)
      (message "No buffer to switch back to."))
    (remhash mode-str smart-scratch--prev-buffers)))

(defun smart-scratch-toggle ()
  "Toggle between the major-mode specific scratch buffer and the current
buffer."
  (interactive)
  (cond ((smart-scratch--special-buffer-p)
         (message "No scratch for current buffer."))
        ((equal (smart-scratch--name) (buffer-name))
         (smart-scratch--switch-back))
        (t
         (smart-scratch--switch-to))))

(provide 'smart-scratch)
