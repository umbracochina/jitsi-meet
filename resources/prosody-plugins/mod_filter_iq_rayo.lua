local st = require "util.stanza";

-- filters rayo iq in case of requested from not jwt authenticated sessions
module:hook("pre-iq/full", function(event)
    local stanza = event.stanza;
    if stanza.name == "iq" then
        local dial = stanza:get_child('dial', 'urn:xmpp:rayo:1');
        if dial then
            local session = event.origin;
            local token = session.auth_token;
            if token == nil then
                module:log("info", "Filtering stanza dial, stanza:%s", tostring(stanza));
                session.send(st.error_reply(stanza, "auth", "forbidden"));
                return true;
            end
        end
    end
    return false;
end);
