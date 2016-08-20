local function do_keyboard_config(chat_id)
    local keyboard = {
        inline_keyboard = {
            {{text = '🛠 Menu', callback_data = 'config:menu:'..chat_id}},
            {{text = '⚡️ Antiflood', callback_data = 'config:antiflood:'..chat_id}},
            {{text = '🌈 Media', callback_data = 'config:media:'..chat_id}},
        }
    }
    
    return keyboard
end
    

local function action(msg, blocks)
    if msg.chat.type == 'private' and not msg.cb then return end
    local chat_id = msg.target_id or msg.chat.id
    local keyboard = do_keyboard_config(chat_id)
    if msg.cb then
        chat_id = msg.target_id
        api.editMessageText(msg.chat.id, msg.message_id, '_Navigate the keyboard to change the settings_', keyboard, true)
    else
        if not roles.is_admin_cached(msg) then return end
        local res = api.sendKeyboard(msg.from.id, '_Navigate the keyboard to change the settings_', keyboard, true)
        if not misc.is_silentmode_on(msg.chat.id) then --send the responde in the group only if the silent mode is off
            if res then
                api.sendMessage(msg.chat.id, '_I\'ve sent you the keyboard in private_', true)
            else
                misc.sendStartMe(msg.chat.id, lang[msg.ln].help.group_not_success, msg.ln)
            end
        end
    end
end

return {
    action = action,
    triggers = {
        config.cmd..'config$',
        '^###cb:config:back:'
    }
}
