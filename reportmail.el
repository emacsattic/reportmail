;; REPORTMAIL: Display time and load in mode line of Emacs.
(defconst reportmail-version "1.7")

;; Originally time.el in the emacs distribution.
;; Mods by BCP, DCP, and JWZ to display incoming mail.
;;
;; Copyright (C) 1985, 1986, 1987 Free Software Foundation, Inc.

;; This file is part of GNU Emacs.

;; License: GPL

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY.  No author or distributor
;; accepts responsibility to anyone for the consequences of using it
;; or for whether it serves any particular purpose or works at all,
;; unless he says so in writing.  Refer to the GNU Emacs General Public
;; License for full details.

;; Everyone is granted permission to copy, modify and redistribute
;; GNU Emacs, but only under the conditions described in the
;; GNU Emacs General Public License.   A copy of this license is
;; supposed to have been given to you along with GNU Emacs so you
;; can know your rights and responsibilities.  It should be in a
;; file named COPYING.  Among other things, the copyright notice
;; and this notice must be preserved on all copies.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Installation
; ------------
;
; To use reportmail, add the following to your .emacs file:
;
;    (load-library "reportmail")
; 
; When new mail arrives, a brief blurb about it will be displayed in the
; mode line, and a more verbose message will be printed in the echo area.
; But unlike most echo-area messages, this message will not go away at
; the next keystroke - it doesn't go away until the next extended-command
; is used.  This is cool because that means you won't miss seeing the 
; subject of the newly-arrived mail because you happened to be typing when
; it arrived.
;
; But if you set the variable `reportmail-flush-echo-area' to t, then this
; message will be cleared every `reportmail-interval' seconds.  This means
; the message will be around for at most 30 seconds or so, which you may
; prefer.
;
; Site Configuration
; ------------------
;
; The variables reportmail-incoming-mail-file and 
; reportmail-message-separator identify the location and format of 
; your waiting messages.  If you are in the CMU SCS environment, or
; are on a generic BSD unix system, this code should work right away.
; Otherwise, you might need to modify the values of these to make things
; work.
;
; Junk Mail
; ---------
;
; The reportmail package has a notion of "junk mail," which can be used to
; reduce the frequency of irritating interruptions by reporting only the
; arrival of messages that seem to be interesting.  If you're on a lot
; of high-volume mailing lists, this can be quite convenient.  To use
; this facility, add something like the following to your .emacs file:
; 
;   ;; The value of this variable is a list of lists, where the first
;   ;; element in each list is the name of a header field and the
;   ;; remaining elements are various elements of the value of this
;   ;; header field that signal the junkiness of a message.  
;   (setq reportmail-junk-mail-checklist
;     '(("From" "bcp" "Benjamin Pierce" "Benjamin.Pierce"
;               "Mail Delivery Subsystem" "network" "daemon@bartok")
;       ("To" "sml-request" "sml-redistribution-request" 
;        "scheme" "TeXhax-Distribution-list")
;       ("Resent-From" "Benjamin.Pierce")
;       ("Sender" "WRITERS" "Haskell" "Electronic Music Digest" "NEW-LIST")))
;   
; By default, the entries in this list are matched exactly as 
; substrings of the given header fields.  If an entry begins with 
; the character ^ it will be matched as a regular expression.  If the 
; variable reportmail-match-using-regexps is set, then all entries
; will be matched as regular expressions.
;
; Note that elements of reportmail-my-addresses are NOT automatically
; included in reportmail-junk-mail-checklist.  If you want mail from
; yourself to be considered junkmail, you must add your addresses to 
; reportmail-junk-mail-checklist too.
;
;
; Xbiff Interface
; ---------------
;
; If you normally keep your emacs window iconified, reportmail can 
; maintain an xbiff or xbiff++ display as well.  The xbiff window will only
; be highlighted when non-junk mail is waiting to be read.  For example:
;
;    (if window-system-version
;        (setq reportmail-use-xbiff t))
;    (setq reportmail-xbiff-arg-list '("-update" "30" "-geometry" "+0+0"))
;    (setq reportmail-xbiff-program "xbiff++")
;
; Other
; -----
;
; There are several other user-customization variables that you may wish
; to modify.  These are documented below.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; HISTORY
;
; Feb 95        Benjamin Pierce (bcp1000@cl.cam.ac.uk)
;       INCOMPATIBLE CHANGE:
;       Changed names: everything beginning with reportmail now
;       begins with reportmail
;
;       Improved error reporting for abnormal startup conditions
;       Integrated with standard emacs19 display-time functionality
;
; Oct 94        Benjamin Pierce (bcp@dcs.ed.ac.uk)
;       Changed Lucid to XEmacs, following the new convention
;
; Jun 94        Benjamin Pierce (bcp@dcs.ed.ac.uk)
;       Some refinements to "From" header parsing
;
; Feb 94        Benjamin Pierce (bcp@dcs.ed.ac.uk)
;       Added version number.  
;       Tries harder to guess values for display-time-incoming-mail-file
;       and display-time-message-separator.
;
; 18 Jan 93     Benjamin Pierce (bcp@cs.cmu.edu)
;       Made field lookup case-insensitive (suggested by JWZ)
;
; 15 oct 92     Benjamin Pierce (bcp@cs.cmu.edu)
;       Merged recent changes
;
; 14 oct 92     Jamie Zawinski <jwz@lucid.com>
;       Added support for xbiff++.
;
; 17 sep 92     Benjamin Pierce (bcp@cs.cmu.edu)
;       Improvements to message display code.
;
; 15 sep 92     Benjamin Pierce (bcp@cs.cmu.edu)
;       Minor bug fixes.
;
; 1 may 92      Jamie Zawinski <jwz@lucid.com>
;       Converted to work with Kyle Jones' timer.el package.
;
; 3 may 91      Jamie Zawinski <jwz@lucid.com>
;       Made the display-time-sentinel make a fuss when the process dies.
;
; 26 mar 91     Jamie Zawinski <jwz@lucid.com>
;       Merged with BCP's latest posted version
;
;  5 mar 91     Jamie Zawinski <jwz@lucid.com>
;       Added compatibility with Emacs 18.57.
;
; 25 Jan 91     Benjamin Pierce (bcp@cs.cmu.edu)
;       Added facility for regular-expression matching of junk-mail
;       checklist.  Set inhibit-local-variables to t inside of 
;       display-time-process-new-mail to prevent letterbombs 
;       (suggested by jwz).
;
; 15 feb 91     Jamie Zawinski <jwz@lucid.com>
;       Made the values of display-time-message-separator and 
;       display-time-incoming-mail-file be initialized when this code
;       starts, instead of forcing the user to do it.  This means that
;       this code can safely be dumped with emacs.  Also, it now notices
;       when it's at CMU, and defaults to something reasonable.  Removed
;       display-time-wait-hard, because I learned how to make echo-area
;       messages be persistent (not go away at the first key).  I wish
;       GC messages didn't destroy it, though...
;
; 20 Dec 90     Jamie Zawinski <jwz@lucid.com>
;       Added new variables: display-time-no-file-means-no-mail, 
;       display-time-wait-hard, and display-time-junk-mail-ring-bell.
;       Made display-time-message-separator be compared case-insensitively.
;       Made the junk-mail checklist use a member-search rather than a 
;       prefix-search.
;
; 22 Jul 90     Benjamin Pierce (bcp@cs.cmu.edu)
;       Added support for debugging.
;
; 19 Jul 90     Benjamin Pierce (bcp@cs.cmu.edu)
;       Improved user documentation and eliminated known CMU dependencies.
;
; 13 Jul 90     Mark Leone (mleone@cs.cmu.edu)
;       Added display-time-use-xbiff option.  Various layout changes.
;
; 20 May 90     Benjamin Pierce (bcp@proof)
;       Fixed a bug that occasionally caused fields to be extracted
;       from the wrong buffer.
;
; 14 May 90     Benjamin Pierce (bcp@proof)
;       Added concept of junk mail and ability to display message
;       recipient in addition to sender and subject.  (Major internal
;       reorganization was needed to implement this cleanly.)
;
; 18 Nov 89     Benjamin Pierce (bcp@proof)
;       Fixed to work when display-time is called with 
;       global-mode-string not a list
;
; 15 Jan 89     David Plaut (dcp@k)
;       Added ability to discard load from displayed string
;
;       To use: (setq display-time-load nil)
;
;       Added facility for reporting incoming mail (modeled after gosmacs
;       reportmail.ml package written by Benjamin Pierce).


(if (or (string-match "Lucid" emacs-version)
        (string-match "XEmacs" emacs-version))
    (require 'itimer)
  (if (string-match "^19" emacs-version)
      (require 'timer)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                       User Variables                          ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar reportmail-announce-mail t
  "*Toggles whether name of mail sender is displayed in mode line.")

(defvar reportmail-announce-junk-mail-too nil
  "*When non-NIL, announce incoming junk mail as well as interesting mail")

(defvar reportmail-time t
  "*Toggles whether the time is displayed.")

(defvar reportmail-load nil
  "*Toggles whether machine load is displayed.")

(defvar reportmail-day-and-date nil
  "*Toggles whether day and date are displayed.")

(defvar reportmail-mail-ring-bell nil
  "*Toggles whether bell is rung on mail arrival.")

(defvar reportmail-junk-mail-ring-bell nil
  "*Toggles whether bell is rung on junk mail arrival.
If reportmail-mail-ring-bell is nil, this variable is ignored.")

(defvar reportmail-my-addresses nil
  "*Report the addressee of incoming mail in the message announcement, 
unless it appears in this list  (See also reportmail-match-using-regexps.)")
;; For example:
;; (setq reportmail-my-addresses
;;  '("Benjamin.Pierce" "bcp" "Benjamin Pierce" "Benjamin C. Pierce"))

(defvar reportmail-junk-mail-checklist nil
  "*A list of lists of strings.  In each sublist, the first component is the
name of a message field and the rest are values that flag a piece of
junk mail.  If an entry begins with the character ^ it is matched as
a regular expression rather than an exact prefix of the given header 
field.  (See also reportmail-match-using-regexps.)  

Note: elements of reportmail-my-addresses are NOT automatically
      included in reportmail-junk-mail-checklist")
;; For example:
;; (setq reportmail-junk-mail-checklist
;;  '(("From" "bcp" "Benjamin Pierce" "Benjamin.Pierce"
;;            "Mail Delivery Subsystem" "network" "daemon@bartok")
;;    ("To" "sml-request" "sml-redistribution-request" "computermusic" 
;;     "scheme" "TeXhax-Distribution-list")
;;    ("Resent-From" "Benjamin.Pierce")
;;    ("Sender" "WRITERS" "Haskell" "Electronic Music Digest" "NEW-LIST")))

(defvar reportmail-match-using-regexps nil "*When non-nil, elements of 
reportmail-junk-mail-checklist and reportmail-my-addresses are matched
as regular expressions instead of literal prefixes of header fields.")

(defvar reportmail-max-from-length 35
  "*Truncate sender name to this length in mail announcements")

(defvar reportmail-max-to-length 11
  "*Truncate addressee name to this length in mail announcements")

(defvar reportmail-interval 30
  "*Seconds between updates of time in the mode line.  Also used
as interval for checking incoming mail.")

(defvar reportmail-no-file-means-no-mail t
  "*Set this to T if you are on a system which deletes your mail-spool file 
when there is no new mail.")

(defvar reportmail-incoming-mail-file nil
  "*User's incoming mail file.  Default is value of environment variable MAIL,
if set;  otherwise /usr/spool/mail/$USER is used.")

(defvar reportmail-message-separator nil)

(defvar reportmail-flush-echo-area nil
  "*If true, then reportmail's echo-area message will be 
automatically cleared when reportmail-interval has expired.")

(defvar reportmail-use-xbiff nil
  "*If set, reportmail uses xbiff to announce new mail.")

(defvar reportmail-xbiff-program "xbiff") ; xbiff++ if you're cool

(defvar reportmail-xbiff-arg-list nil
  "*List of arguments passed to xbiff.  Useful for setting geometry, etc.")
;;; For example: 
;;; (setq reportmail-xbiff-arg-list '("-update" "30" "-geometry" "+0+0"))

(defvar reportmail-mail-arrived-file nil
  "New mail announcements saved in this file if xbiff used.  Deleted when 
mail is read.  Xbiff is used to monitor existence of this file.
This file will contain the headers (and only the headers) of all of the
messages in your inbox.  If you do not wish this to be readable by others, 
you should name a file here which is in a protected directory.  Protecting
the file itself is not sufficient, because the file gets deleted and
recreated, and emacs does not make it easy to create protected files.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                       Internal Variables                      ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar reportmail-loadst-process nil
  "The process providing time, load, and mail info.")

(defvar reportmail-xbiff-process nil
  "The xbiff process used to announce incoming mail.")

(defvar reportmail-string nil
  "Time displayed in mode line")

(defvar reportmail-mail-buffer-name "*Mail*"
  "Name of buffer used for announcing mail.")

(defvar reportmail-may-need-to-reset t
  "Set to NIL when reportmail-total-reset has not been called 
since the last time we changed from having mail in the queue to an empty
queue.")

(defvar reportmail-debugging nil
  "*When non-NIL, reportmail records various status information
as it's working.")

(defvar reportmail-debugging-delay nil 
   "*When non-nil and reportmail-debugging is set, sit for this 
long after displaying each debugging message in mode line")

(defvar reportmail-debugging-buffer "*Reportmail-Debugging*"
  "Status messages are appended here.")
  
(defvar reportmail-max-debug-info 20000
  "Maximum size of debugging buffer")

(defvar reportmail-timer nil
  "The timer process, when using the 'timer package")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                       Macros                                  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro reportmail-del-file (filename)
  (list 'if (list 'file-exists-p filename) (list 'delete-file filename)))

(defmacro reportmail-debug (mesg &rest args)
  (list
     'if 'reportmail-debugging
         (list 'reportmail-debug-mesg
               (append (list 'format mesg) args))))

(defun reportmail-init ()
  ;; If the mail-file isn't set, figure it out.
  (or reportmail-incoming-mail-file
      (setq reportmail-incoming-mail-file
            (let* ((user-name (or (getenv "USER") (user-login-name)))
		   (guess1 (concat "/usr/spool/mail/" user-name))
		   (guess2 (concat (getenv "HOME") "/.mail")))
              (or (getenv "MAIL")
                  (if (file-exists-p guess1) guess1)
                  guess2))))
  ;; If the message-separator isn't set, try to guess a good value.
  (or reportmail-message-separator
      (setq reportmail-message-separator
              (cond 
               ;; Is it an MMDF mailbox (e.g. at Edinburgh)?
               ((string= 
                 (file-name-nondirectory reportmail-incoming-mail-file)
                 ".mail")
                "\C-a\C-a\C-a\C-a\n\C-a\C-a\C-a\C-a")
               ;; Are we at CMU?
               ((let ((case-fold-search t)) 
                  (string-match "\\.cmu\\.edu" (system-name)))
                "\^C")
               ;; By default, use "From "
               (t 
                "From "))))
  ;; if this isn't set, these are probably right...
  (or reportmail-my-addresses
      (setq reportmail-my-addresses
            (list (user-full-name) (user-login-name))))
  ;;
  (or reportmail-mail-arrived-file
      (setq reportmail-mail-arrived-file
            (expand-file-name ".mail-arrived" (getenv "HOME"))))
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                       Time Display                            ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun reportmail-kill ()
  "Kill all reportmail processes.  Done automatically if reportmail
is re-invoked."
  (interactive)
  (reportmail-debug "reportmail-kill")
  (if reportmail-loadst-process (delete-process reportmail-loadst-process))
  (if reportmail-xbiff-process (delete-process reportmail-xbiff-process))
)

(defun reportmail ()
  "Displays current time, date, load level, and incoming mail status in 
mode line of each buffer (if corresponding user variables are set)."
  (interactive)
  (reportmail-debug "reportmail")
  (reportmail-init)
  (let ((process-connection-type nil))  ; UIUCDCS mod
    (save-excursion
      (reportmail-kill)
      (if (or (string-equal "" reportmail-incoming-mail-file)
              (and (not reportmail-no-file-means-no-mail)
                   (not (file-exists-p reportmail-incoming-mail-file))))
          (progn 
             (message "Reportmail: mail spool file \"%s\" not found" 
                      reportmail-incoming-mail-file)
             (sit-for 1)
             (ding nil)))
      (if (not global-mode-string) (setq global-mode-string '("")))
      (if (not (listp global-mode-string))
          (setq global-mode-string (list global-mode-string "  ")))
      (if (not (memq 'reportmail-string global-mode-string))
          (setq global-mode-string
                (append global-mode-string '(reportmail-string))))
      (setq reportmail-string "time and load")
      
      (cond
       ;; If we have Emacs19 timers, use them
       ((featurep 'timer)
        (if reportmail-timer (cancel-timer reportmail-timer))
        (setq reportmail-timer 
              (run-at-time
               "1 sec" reportmail-interval 'reportmail-timer-function)))
       ;; If we've got the standard emacs19 time package, use it
       ((boundp 'display-time-hook)
        (setq display-time-hook 'reportmail-timer-function))
       ;; If we have XEmacs timers, use them
       ((featurep 'timer)
        (let ((old (get-timer "reportmail")))
          (if old (delete-timer old))
          (start-timer "reportmail" 'reportmail-timer-function
                       reportmail-interval reportmail-interval)
          (reportmail-timer-function)))
       ;; Otherwise, then use one of the process mechanisms.
       (t
        (setq reportmail-loadst-process
              (if (string-match "18\\.5[0-5]" (emacs-version))
                  (start-process "reportmail-loadst" nil
                                 "loadst" 
                                 "-n" (int-to-string reportmail-interval))
                (start-process 
                 "reportmail-wakeup" nil
                 (let ((executable (concat exec-directory "wakeup")))
                   (if (file-exists-p executable)
                       executable
                     (error "Reportmail: %s not found" executable)))
                 (int-to-string reportmail-interval))))
        (process-kill-without-query reportmail-loadst-process)
        (set-process-sentinel reportmail-loadst-process 
                              'reportmail-sentinel)
        (set-process-filter reportmail-loadst-process
                            (if (string-match "18\\.5[0-5]" (emacs-version))
                                'reportmail-filter-18-55
                              'reportmail-filter-18-57))))
      
      (if reportmail-use-xbiff
          (progn
            (reportmail-del-file reportmail-mail-arrived-file)
            (setq reportmail-xbiff-process
                  (apply 'start-process "reportmail-xbiff" nil
                         reportmail-xbiff-program
                         "-file" reportmail-mail-arrived-file
                         reportmail-xbiff-arg-list))
            (process-kill-without-query reportmail-xbiff-process)
            (sit-for 1)                 ; Need time to see if xbiff fails.
            (if (/= 0 (process-exit-status reportmail-xbiff-process))
                (error "Display time: xbiff failed. Check xbiff-arg-list"))))))
  (reportmail-total-reset))

(defun reportmail-sentinel (proc reason)
  ;; notice if the process has died an untimely death...
  (reportmail-debug "reportmail-sentinel")
  (cond ((memq (process-status proc) '(stop exit closed signal))
         (if (and (stringp reason) (string-match "\n?\n*\\'" reason))
             (setq reason (substring reason 0 (match-beginning 0))))
         (ding)
         (setq reportmail-string (format "%s" reason))
         (reportmail-message "")
         (message "process %s: %s (%s)" proc reason (process-status proc))))
  (reportmail-force-redisplay))

(defun reportmail-filter-18-55 (proc string)
  (if reportmail-flush-echo-area (reportmail-message ""))
  ;; Desired data can't need more than the last 30 chars,
  ;; so save time by flushing the rest.
  ;; This way, if we have many different times all collected at once,
  ;; we can discard all but the last few very fast.
  (reportmail-debug "reportmail-filter-18-55")
  (if (> (length string) 30) (setq string (substring string -30)))
  ;; Now discard all but the very last one.
  (while (and (> (length string) 4)
              (string-match "[0-9]+:[0-9][0-9].." string 4))
    (setq string (substring string (match-beginning 0))))
  (if (string-match "[^0-9][0-9]+:" string)
      (setq string (substring string 0 (1+ (match-beginning 0)))))
  ;; If we're announcing mail and mail has come, process any new messages
  (if reportmail-announce-mail
      (if (string-match "Mail" string)
          (reportmail-process-new-mail)
          (reportmail-total-reset)))
  ;; Format the mode line time display
  (let ((time-string (if (string-match "Mail" string)
                         (if reportmail-announce-mail 
                             reportmail-mail-modeline
                             "Mail "))))
    (if (and reportmail-time (string-match "[0-9]+:[0-9][0-9].." string))
        (setq time-string 
              (concat time-string
                      (substring string (match-beginning 0) (match-end 0))
                      " ")))
    (if reportmail-day-and-date
        (setq time-string
              (concat time-string
                      (substring (current-time-string) 0 11))))
    (if (and reportmail-load (string-match "[0-9]+\\.[0-9][0-9]" string))
        (setq time-string
              (concat time-string
                      (substring string (match-beginning 0) (match-end 0))
                      " ")))
    ;; Install the new time for display.
    (setq reportmail-string time-string)
    (reportmail-force-redisplay)))

(defun reportmail-filter-18-57 (proc string) ; args are ignored
  (reportmail-debug "reportmail-filter-18-57")
  (if reportmail-flush-echo-area
      (progn
        (reportmail-debug "flush echo area")
        (reportmail-message "")))
  (let ((mailp (and (file-exists-p reportmail-incoming-mail-file)
                    (not (eq 0 (nth 7 (file-attributes
                                       reportmail-incoming-mail-file)))))))
    (if reportmail-announce-mail
        (if mailp
            (reportmail-process-new-mail)
            (reportmail-total-reset)))
    ;; Format the mode line time display
    (let ((time-string (if mailp
                           (if reportmail-announce-mail
                               reportmail-mail-modeline
                               "Mail "))))
      (if reportmail-time
          (let* ((time (current-time-string))
                 (hour (read (substring time 11 13)))
                 (pm (>= hour 12)))
            (if (> hour 12) (setq hour (- hour 12)))
            (if (= hour 0) (setq hour 12))
            (setq time-string
                  (concat time-string
                          (format "%d" hour) (substring time 13 16)
                          (if pm "pm " "am ")))))
      (if reportmail-day-and-date
          (setq time-string
                (concat time-string
                        (substring (current-time-string) 0 11))))
      (if reportmail-load
          (setq time-string
              (concat time-string
                      (condition-case ()
                          (if (zerop (car (load-average)))
                              ""
                              (format "%03d" (car (load-average))))
                        (error "load-error"))
                      " ")))
      ;; Install the new time for display.
      (setq reportmail-string time-string)

      (reportmail-force-redisplay))))

(defun reportmail-timer-function ()
  (reportmail-filter-18-57 nil nil))

(defun reportmail-force-redisplay ()
  "Force redisplay of all buffers' mode lines to be considered."
  (save-excursion (set-buffer (other-buffer)))
  (set-buffer-modified-p (buffer-modified-p))
  ;; Do redisplay right now, if no input pending.
  (sit-for 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                       Mail processing                         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar reportmail-mail-who-from ""
  "Short-form name of sender of last piece of interesting unread mail")

(defvar reportmail-mail-modeline ""
  "Terse mail announcement (displayed in modeline)")

(defvar reportmail-previous-mail-buffer-max 1
  "The length of the mail buffer the last time we looked at it")

(defvar reportmail-msg-count 0
  "How many interesting messages have arrived")

(defvar reportmail-junk-msg-count 0
  "How many junk messages have arrived")


;; A test procedure for trying out new reportmail features
; (defun reportmail-test ()
;  (interactive)
;  (reportmail-total-reset)
;  (reportmail-process-new-mail))

(defun reportmail-manual-reset ()
  "Utility function to be called externally to make reportmail notice
that things may have changed."
  (interactive)
  (reportmail-debug "Manual reset")
  (reportmail-timer-function))

(defun reportmail-total-reset ()
  (reportmail-debug "reportmail-total-reset")
  (if reportmail-may-need-to-reset
   (progn
    (setq reportmail-may-need-to-reset nil)
    (reportmail-debug "Resetting mail processing")
    (let ((mail-buffer (get-buffer reportmail-mail-buffer-name)))
      (if mail-buffer (kill-buffer mail-buffer)))
    (if reportmail-use-xbiff
        ;; This function is only called when no mail is in the spool.
        ;; Hence we should delete the mail-arrived file.
        (reportmail-del-file reportmail-mail-arrived-file))
    (reportmail-reset)
    )))

(defun reportmail-reset ()
  (reportmail-debug "reportmail-reset")
  (setq reportmail-msg-count 0)
  (setq reportmail-junk-msg-count 0)
  (setq reportmail-mail-who-from "Junk mail")
  (setq reportmail-mail-modeline "")
  (setq reportmail-previous-mail-buffer-max 1)
  (reportmail-message "") ; clear the echo-area.
  )

(defun reportmail-process-new-mail ()
  (setq reportmail-may-need-to-reset t)
  (let ((mail-buffer (get-buffer reportmail-mail-buffer-name))
        (inhibit-local-variables t)
        (enable-local-variables nil))
    (if (not (and mail-buffer (verify-visited-file-modtime mail-buffer)))
      (save-window-excursion
       (save-excursion
        (reportmail-debug "Spool file has changed... rereading...")
        (if mail-buffer (kill-buffer mail-buffer))
        ;; Change to pop-to-buffer when we're debugging:
        (set-buffer (find-file-noselect reportmail-incoming-mail-file))
        (rename-buffer reportmail-mail-buffer-name)
        (reportmail-process-mail-buffer))))))

(defun reportmail-process-mail-buffer ()
  (if (< reportmail-previous-mail-buffer-max (point-max))
      (let ((case-fold-search nil))
        (goto-char reportmail-previous-mail-buffer-max)
        (if (not (looking-at
                  (regexp-quote reportmail-message-separator)))
            (reportmail-reset)))
    (reportmail-reset))
  (goto-char reportmail-previous-mail-buffer-max)
  (let ((case-fold-search nil)
        (start (point))
        end)
    (while (not (eobp))
      (if (search-forward (concat "\n" reportmail-message-separator)
                          nil 'end)
          (setq end (1+ (match-beginning 0)))
        (setq end (point-max)))
      (narrow-to-region start end)
      (reportmail-process-this-message)
      (widen)
      (goto-char (if (= end (point-max)) (point-max) (1+ end)))
      (setq start end)
      ))
  (setq reportmail-previous-mail-buffer-max (point-max)))

; Mine:
; (defun reportmail-process-mail-buffer ()
;   (reportmail-debug "reportmail-process-mail-buffer")
;   (let (start)
;     (if (< reportmail-previous-mail-buffer-max (point-max))
;       (let ((case-fold-search nil))
;         (goto-char reportmail-previous-mail-buffer-max)
;         (if (not (looking-at
;                   (regexp-quote reportmail-message-separator)))
;             (reportmail-reset)))
;       (reportmail-reset))
;     (goto-char reportmail-previous-mail-buffer-max)
;     (if (not (eobp))
;       (forward-char 1))
;     (while (not (eobp))
;       (reportmail-debug "Finding next message")
;       (setq start (point))
;       (if (not (let ((case-fold-search nil))
;                (search-forward 
;                 (concat "\n" reportmail-message-separator) nil t)))
;         (goto-char (point-max)))
;       (narrow-to-region start (point))
;       (reportmail-process-this-message)
;       (goto-char (point-max))
;       (widen))
;     (setq reportmail-previous-mail-buffer-max (point-max))))

(defun reportmail-process-this-message ()
  (reportmail-debug "reportmail-process-this-message")

  (if (reportmail-junk-message)
      (reportmail-process-junk-message)
      (reportmail-process-good-message))
  
  ;; Update mode line contents
  (setq reportmail-mail-modeline 
        (if (or (> reportmail-msg-count 0) 
                reportmail-announce-junk-mail-too)
            (concat "[" (reportmail-format-msg-count) 
                    reportmail-mail-who-from
                    "] ")
          ""))
  (reportmail-debug "New mode line: %s " reportmail-mail-modeline)
  )

(defun reportmail-junk-message ()
  "Check to see whether this message is interesting"

  (reportmail-debug "Comparing current message to junk mail checklist")

  (let ((checklist reportmail-junk-mail-checklist)
        (junk nil))
    (while (and checklist (not junk))
      (if (reportmail-member 
           (reportmail-get-field (car (car checklist)))
           (cdr (car checklist)))
          (setq junk t)
          (setq checklist (cdr checklist))))
    junk))

(defun reportmail-message (&rest message-args)
  (let ((str (apply 'format message-args))
        (in-echo-area-already (eq (selected-window) (minibuffer-window))))
    ;; don't stomp the echo-area-buffer if reading from the minibuffer now.
    (reportmail-debug "reportmail-message (%s)" str)
    (if (not in-echo-area-already)
        (save-excursion
          (save-window-excursion
            (reportmail-debug "Overwriting echo area with message")
            (select-window (minibuffer-window))
            (delete-region (point-min) (point-max))
            (insert str))))
    ;; if we're reading from the echo-area, and all we were going to do is
    ;; clear the thing, like, don't bother, that's annoying.
    (if (and in-echo-area-already (string= "" str))
        nil
      (message "%s" str))
    ))

(defun reportmail-process-good-message ()
  (reportmail-debug "Formatting message announcement (good message)")

  ;; Update the message counter
  (setq reportmail-msg-count (+ reportmail-msg-count 1))

  ;; Format components of announcement
  (let* ((subject (reportmail-get-field "Subject" ""))
         (from (reportmail-get-field "From" ""))
         (to (reportmail-get-field "To" ""))
         (print-subject (if (string= subject "")
                            ""
                            (concat " (" subject ")")))
         (print-from (reportmail-truncate from reportmail-max-from-length))
         (short-from (reportmail-truncate 
                      (reportmail-extract-short-addr from) 25))
         (print-to (if (reportmail-member to reportmail-my-addresses)
                       ""
                       (reportmail-truncate 
                        (reportmail-extract-short-addr to)
                        reportmail-max-to-length))))

    ;; Announce message
    (let ((msg (concat 
                   (reportmail-format-msg-count)
                   "Mail " 
                   (if (string= print-to "") "" 
                       (concat "to " print-to " "))
                   "from " print-from 
                   print-subject)))
      (if reportmail-use-xbiff
          (save-excursion
            (let* ((tmp-buf (get-buffer-create " *reportmail-tmp*"))
                   (buf (current-buffer))
                   (start (point-min))
                   (end (save-excursion
                          (goto-char start)
                          (search-forward "\n\n" nil 0)
                          (point))))
              (set-buffer tmp-buf)
              (erase-buffer)
              (insert-buffer-substring buf start end)
              (insert "\n\n")
              (append-to-file (point-min) (point-max) 
                              reportmail-mail-arrived-file)
              (erase-buffer)
              ;;(kill-buffer tmp-buf)
              )))
      (reportmail-debug "Message: %s" msg)
      (reportmail-message "%s" msg))

    (if reportmail-mail-ring-bell (ding))
    
    ;; Update mode line information
    (setq reportmail-mail-who-from short-from)))

(defun reportmail-process-junk-message ()
  (reportmail-debug "Formatting message announcement (junk message)")

  ;; Update the message counter
  (setq reportmail-junk-msg-count (+ reportmail-junk-msg-count 1))

  ;; Format components of announcement
  (let* ((subject (reportmail-get-field "Subject" ""))
         (from (reportmail-get-field "From" ""))
         (to (reportmail-get-field "To" ""))
         (print-subject (if (string= subject "")
                            ""
                            (concat " (" subject ")")))
         (print-from (reportmail-truncate from reportmail-max-from-length))
         (short-from (reportmail-truncate 
                      (reportmail-extract-short-addr from) 25))
         (print-to (if (reportmail-member to reportmail-my-addresses)
                       ""
                       (reportmail-truncate 
                        (reportmail-extract-short-addr to)
                        reportmail-max-to-length))))

    ;; Announce message
    (if reportmail-announce-junk-mail-too
          (let ((msg (concat 
                      (reportmail-format-msg-count)
                      "Junk Mail " 
                      (if (string= print-to "") "" 
                        (concat "to " print-to " "))
                      "from " print-from 
                      print-subject)))
;           (if reportmail-use-xbiff
;               (save-excursion
;                 (let ((tmp-buf (generate-new-buffer "*Tmp*")))
;                   (set-buffer tmp-buf)
;                   (insert msg)
;                   (newline)
;                   (append-to-file (point-min) (point-max) 
;                                   reportmail-mail-arrived-file)
;                   (kill-buffer tmp-buf))))
            (reportmail-message "%s" msg)
            (reportmail-debug "Message: %s" msg)
            (if (and reportmail-mail-ring-bell
                     reportmail-junk-mail-ring-bell)
                (ding))))))

(defun reportmail-format-msg-count ()
   (if (> (+ reportmail-msg-count reportmail-junk-msg-count) 1) 
       (concat 
        (int-to-string reportmail-msg-count) 
        (if (> reportmail-junk-msg-count 0)
            (concat "(" (int-to-string reportmail-junk-msg-count) ")"))
        ": ")
       ""))

(defun reportmail-get-field (field &optional default)
  (cond ((not (equal (buffer-name) reportmail-mail-buffer-name))
    (beep)
    (message "reportmail bug: processing buffer %s, not %s"
	     (buffer-name)
	     reportmail-mail-buffer-name)
    (sit-for 2)))
  (goto-char (point-min))
  (let* ((case-fold-search t)
	 (result
	 (if (re-search-forward (concat "^" field ":[ |\C-i]*") nil t)
	     (let ((start (point)))
	       (end-of-line)
	       (while (looking-at "\n[ \t]")
		 (forward-line 1)
		 (end-of-line))
	       (buffer-substring start (point)))
	     (or default "<unknown>"))))
    (reportmail-debug "value of %s field is %s" field result)
    result))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                       Auxilliary Functions                    ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun reportmail-member (e l)
  "Is string E matched by an element of list L?  
When an element of L begins with ^, match it as a regexp.  Otherwise,
ignore case and match exactly.  If reportmail-match-using-regexps is
non-nil, always match using regexps."
  (let ((done nil)
        (result nil))
    (while (not done)
      (cond 
       ((null l) (setq done t))
       ((or reportmail-match-using-regexps (= (elt (car l) 0) ?^))
        (if (string-match (car l) e)
            (setq result l done t)
          (setq l (cdr l))))
       ((string-match (regexp-quote (downcase (car l))) (downcase e)) 
        (setq result l done t))
       (t 
        (setq l (cdr l)))))
    result))

(defun reportmail-truncate (s max)
  (if (and s (>= (length s) max))
      (concat (substring s 0 max) "\\")
      s))

(defun reportmail-extract-short-addr (long-addr)
  (let ((name "\\([-A-Za-z0-9_+\\.' ]+\\)"))
    (if (or 
         ;; David Plaut <dcp@CS.CMU.EDU>         -> David Plaut
         (string-match (concat name "[ |        ]+<.+>") long-addr)
        
         ;; anything (David Plaut) anything      -> David Plaut
         (string-match ".+(\\(.+\\)).*" long-addr)
         
         ;; anything "David Plaut" anything      -> David Plaut
         (string-match ".*\"\\(.+\\)\".*" long-addr)
         
         ;; plaut%address.bitnet@vma.cc.cmu.edu -> plaut
         (string-match (concat name "%.+@.+") long-addr)

         ;; random!uucp!addresses!dcp@uu.relay.net -> dcp
         (string-match (concat ".*!" name "@.+") long-addr)

         ;; David.Plaut@CS.CMU.EDU               -> David.Plaut
         (string-match (concat name "@.+") long-addr)
         )
        (substring long-addr (match-beginning 1) (match-end 1))
        long-addr)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                       Debugging Support                       ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar reportmail-debugging-messages nil
  "When non-NIL, reportmail displays status messages in real time.")

(defun reportmail-debug-mesg (mesg)
  (if reportmail-debugging-messages
      (progn 
        (message "Reportmail: %s" mesg)
        (sit-for 1)
        ))
  (save-excursion
    (save-window-excursion
      (set-buffer (get-buffer-create reportmail-debugging-buffer))
      (goto-char (point-max))
      (insert (substring (current-time-string) 11 16) "  " mesg "\n")
      ;; Make sure the debugging buffer doesn't get out of hand
      (if (> (point-max) reportmail-max-debug-info)
          (delete-region (point-min) 
                         (- (point-max) reportmail-max-debug-info)))))
  (if reportmail-debugging-delay
      (progn (message "Reportmail: %s" mesg)
             (sit-for reportmail-debugging-delay))))

(provide 'reportmail)
(reportmail)
