SMODS.Voucher {
    key = 'welcomeback',
    atlas = "Misc",
    pos = { x = 1, y = 0 },
    config = { extra = { deduction = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.deduction } }
    end,
    redeem = function(self, card)
        ease_ante(-card.ability.extra.deduction)
        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante - card.ability.extra.deduction
    end
}

SMODS.Voucher {
    key = 'counterclockwise',
    atlas = "Misc",
    pos = { x = 2, y = 0 },
    config = { extra = { deduction = 1, slots = 1} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.deduction, card.ability.extra.slots } }
    end,
    requires = { 'v_kls_welcomeback' },
    redeem = function(self, card)
        ease_ante(-card.ability.extra.deduction)
        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante - card.ability.extra.deduction
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.jokers then
                    G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
                end
                return true
            end,
        }))
    end
}