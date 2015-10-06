options.timeout = 120
options.subscribe = true
options.expunge = true

package.path = package.path .. ';' .. os.getenv("HOME") .. '/.imapfilter/?.lua'

-- Get account information - imap server info, username from environment, and prompts for the password
require('account')

-- 
function filter_mail()
    repeat
        repeat
            initial = account.presort:select_all()

            -- filter Spam based on spamassassin flags
            res = account.presort:match_field('X-Spam-Flag', 'YES')
            res:move_messages(account['SPAM'])
    
            -- all apple lists
            res = account.presort:contain_to('@lists.apple.com')
                + account.presort:contain_cc('@lists.apple.com')
                + account.presort:contain_from('@lists.apple.com')
            res:move_messages(account['apple'])
    
            -- linkedin
            res = account.presort:contain_to('@linkedin.com')
                + account.presort:contain_cc('@linkedin.com')
                + account.presort:contain_from('@linkedin.com')
            res:move_messages(account['linkedin'])
    
            -- freebsd
            res = account.presort:contain_to('@freebsd.org')
                + account.presort:contain_cc('@freebsd.org')
            res:move_messages(account['freebsd'])

            -- nanog
            res = account.presort:contain_to('@nanog.org')
                + account.presort:contain_cc('@nanog.org')
            res:move_messages(account['nanog'])

            -- bugtraq
            res = account.presort:contain_to('@securityfocus.com')
                + account.presort:contain_cc('@securityfocus.com')
                + account.presort:match_field('List-Id', '<bugtraq.list-id.securityfocus.com>')
                + account.presort:match_field('Delivered-To', 'mailing list bugtraq@securityfocus.com')
            res:move_messages(account['bugtraq'])
    
            res = account.presort:contain_to('@seclists.org')
                + account.presort:contain_cc('@seclists.org')
            res:move_messages(account['fulldisclosure'])
    
            res = account.presort:contain_subject('ASA ALERT')
            res:move_messages(account['subnet88'])

            -- redhat  
            res = account.presort:contain_to('@redhat.com')
                + account.presort:contain_cc('@redhat.com')
                + account.presort:contain_to('@fedoraproject.org')
                + account.presort:contain_cc('@fedoraproject.org')
                + account.presort:contain_to('@lists.fedoraproject.org')
                + account.presort:contain_cc('@lists.fedoraproject.org')
            res:move_messages(account['redhat'])

            -- cypherpunks
            res = account.presort:match_field('Return-Path', '@cpunks.org')
                + account.presort:match_field('Sender', '@cpunks.org')
                + account.presort:match_field('List-Id', 'Cypherpunks Mailing List')
                + account.presort:match_field('List-Post', 'cypherpunks@cpunks.org')
            res:move_messages(account['cpunks'])
    
            res = initial * account.presort:select_all()
            res:move_messages(account.INBOX)
    
            res = account.presort:select_all() - initial
        until #res == 0
    until not account.presort:enter_idle()
end

become_daemon(60, filter_mail)
