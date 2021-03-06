;;; packages.el --- bj-reason layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Bryan Joseph <bryanjos@bryanjos>
;; URL: https://github.com/bryanjos/spacemacs-private
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `bj-reason-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `bj-reason/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `bj-reason/pre-init-PACKAGE' and/or
;;   `bj-reason/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst bj-reason-packages
  '(
    merlin
    (reason-mode :location local)
    (refmt :location local)
    )
  "The list of Lisp packages required by the bj-reason layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")


(defun bj-reason/init-refmt ()
  (use-package refmt))

(defun bj-reason/post-init-merlin ())

(defun bj-reason/init-reason-mode ()
  (use-package reason-mode
    :init
    (progn

      (add-to-list 'auto-mode-alist '("\\.re\\'" . reason-mode))
      (add-to-list 'auto-mode-alist '("\\.rei\\'" . reason-mode))
      (setq opam (substring (shell-command-to-string "opam config var prefix 2> /dev/null") 0 -1))
      (add-to-list 'load-path (concat opam "/share/emacs/site-lisp"))
      (setq refmt-command (concat opam "/bin/refmt"))
      (add-hook 'reason-mode-hook (lambda ()
                                    (add-hook 'before-save-hook 'refmt-before-save)
                                    (merlin-mode)))
    )
    ))


;;; packages.el ends here
