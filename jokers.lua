SMODS.Joker{
    key = "white",
    unlocked = true,
    config = { extra = {dollars = 3} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    rarity = 2,
    atlas = "Jokers",
    blueprint_compat = true,
    pos = {x = 0, y = 0},
    cost = 7,
    calculate = function(self, card, context)
        if context.before and next(context.poker_hands["Flush Five"]) then
            return {
                dollars = card.ability.extra.dollars
            }
        end
    end
}

SMODS.Joker{
    key = "black",
    unlocked = true,
    rarity = 2,
    atlas = "Jokers",
    blueprint_compat = false,
    pos = {x = 1, y = 0},
    cost = 7,
}

function black_check(card, suit)
    if ((card.base.suit == "Spades" or card.base.suit == "Diamonds") and (suit == "Spades" or suit == "Diamonds")) then
        return true
    elseif (card.base.suit == "Hearts" or card.base.suit == "Clubs") and (suit == "Hearts" or suit == "Clubs") then
        return true
    end
    return false
end

local card_is_suit_ref = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
    local ret = card_is_suit_ref(self, suit, bypass_debuff, flush_calc)
    if not ret and not SMODS.has_no_suit(self) and next(SMODS.find_card("j_kls_black")) then
        return black_check(self, suit)
    end
    return ret
end

SMODS.Joker{
    key = "red",
    unlocked = true,
    blueprint_compat = false,
    config = { extra = {odds = 3} },
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds} }
    end,
    rarity = 3,
    atlas = "Jokers",
    pos = {x = 3, y = 0},
    cost = 7,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            local eval = function() return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.discard and not context.blueprint and
            G.GAME.current_round.discards_used <= 0 then 
                return {
                    remove = true
                }
        end
    end
}

SMODS.Joker {
	key = "blue",
	config = { extra = { chips = 0, chip_gain = 7 } },
	rarity = 2,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 2, y = 0 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize { type = "variable", key = "a_chips", vars = { card.ability.extra.chips } }
			}
		end

		if context.end_of_round and not context.blueprint and context.main_eval then
			card.ability.extra.chips = card.ability.extra.chips + (card.ability.extra.chip_gain * G.GAME.current_round.hands_left)
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.CHIPS,
				card = card
			}
		end
	end
}

SMODS.Joker {
	key = "yellow",
	config = { extra = { dollars = 6 } },
	rarity = 2,
	atlas = "Jokers",
    blueprint_compat = false,
	pos = { x = 1, y = 1 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.dollars } }
	end,
    calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint and #G.jokers.cards > 1 then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.2,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.jokers:shuffle("yellow")
                            play_sound("cardSlide1", 0.85)
                            return true
                        end,
                    }))
                    delay(0.15)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.jokers:shuffle("yellow")
                            play_sound("cardSlide1", 1.15)
                            return true
                        end
                    }))
                    delay(0.15)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.jokers:shuffle("yellow")
                            play_sound("cardSlide1", 1)
                            return true
                        end
                    }))
                    delay(0.5)
                    return true
                end
            }))
		end
	end,
	calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars
    end
}

SMODS.Joker {
	key = "green",
	config = { extra = { chips = 0, chip_gain = 30 } },
	rarity = 2,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 3, y = 1 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize { type = "variable", key = "a_chips", vars = { card.ability.extra.chips } }
			}
		end

		if context.reroll_shop and not context.blueprint and context.main_eval then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
			return {
				message = localize { type = "variable", key = "a_chips", vars = { card.ability.extra.chips } },
				colour = G.C.CHIPS,
				card = card
			}
		end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if G.GAME.blind.boss and card.ability.extra.chips > 1 then
                card.ability.extra.chips = 0
                return {
                    message = localize('k_reset'),
                    colour = G.C.CHIPS
                }
            end
        end
	end
}

SMODS.Joker {
	key = "purple",
	config = { extra = { xmult = 2 } },
	rarity = 3,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 4, y = 0 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult} }
	end,
	calculate = function(self, card, context)
        if context.other_joker and context.other_joker.config.center.original_mod == SMODS.Mods["KLS"] then
            return {
                xmult = card.ability.extra.xmult
            }
        end
	end
}

SMODS.Joker {
	key = "brown",
	config = { extra = { percent = 40 } },
	rarity = 3,
	atlas = "Jokers",
    blueprint_compat = false,
	pos = { x = 4, y = 1 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.percent } }
	end,
	add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.discount_percent = G.GAME.discount_percent - card.ability.extra.percent
                G.GAME.win_ante = G.GAME.win_ante - 1
                for _, v in pairs(G.I.CARD) do
                    if v.set_cost then v:set_cost() end
                end
                return true
            end
        }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.discount_percent = G.GAME.discount_percent + card.ability.extra.percent
                G.GAME.win_ante = G.GAME.win_ante + 1
                for _, v in pairs(G.I.CARD) do
                    if v.set_cost then v:set_cost() end
                end
                return true
            end
        }))
    end
}

SMODS.Joker {
	key = "hui1", -- I can't decide which spelling of græy to use, so I just resorted to the Chinese word for it (灰)
	config = { extra = { chips = 50, mult = 10, xmult = 1.07, xmult_gain = 0.03 } },
	rarity = 3,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 2, y = 1 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.xmult, card.ability.extra.xmult_gain, card.ability.extra.xmult + card.ability.extra.xmult_gain * G.GAME.hands["High Card"].level} }
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_stone") then
            local stone_cards = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if SMODS.has_enhancement(scored_card, "m_stone") then
                    stone_cards = stone_cards + 1
                end
            end
            if stone_cards >= 5 then
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                    xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain * G.GAME.hands["High Card"].level,
                    card = context.other_card
                }
            else
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                    card = context.other_card
                }
            end
        end
	end
}

SMODS.Joker {
	key = "orange",
	config = { extra = { dollars = 1 } },
	rarity = 2,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 0, y = 1 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.dollars} }
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() >= 10 then
            return {
                dollars = 1
            }
        end
    end
}

SMODS.Joker {
	key = "magenta",
	config = { extra = { xmult = 1.5 } },
	rarity = 2,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 3, y = 2 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
        local rank = (G.GAME.current_round.kls_mg_card or {}).rank or 'Ace'
		return { vars = { card.ability.extra.xmult, rank } }
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            context.other_card:get_id() == G.GAME.current_round.kls_mg_card.id then
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            return {
                message = localize('k_reset'),
                colour = G.C.MULT
            }
        end
    end
}

local function reset_kls_magenta_rank()
    G.GAME.current_round.kls_mg_card = { rank = 'Ace' }
    local valid_mg_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_rank(playing_card) then
            valid_mg_cards[#valid_mg_cards + 1] = playing_card
        end
    end
    local mg_card = pseudorandom_element(valid_mg_cards, 'magenta' .. G.GAME.round_resets.ante)
    if mg_card then
        G.GAME.current_round.kls_mg_card.rank = mg_card.base.value
        G.GAME.current_round.kls_mg_card.id = mg_card.base.id
    end
end

SMODS.Joker {
	key = "lime",
	config = { extra = { xmult = 1.2 } },
	rarity = 2,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 2, y = 2 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
        local suit = (G.GAME.current_round.kls_lm_card or {}).suit or 'Spades'
		return { vars = { card.ability.extra.xmult, suit, colours = { G.C.SUITS[suit] } } }
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            context.other_card:is_suit(G.GAME.current_round.kls_lm_card.suit) then
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            return {
                message = localize('k_reset'),
                colour = G.C.MULT
            }
        end
    end
}

local function reset_kls_lime_suit()
    G.GAME.current_round.kls_lm_card = { suit = 'Spades' }
    local valid_lm_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_suit(playing_card) then
            valid_lm_cards[#valid_lm_cards + 1] = playing_card
        end
    end
    local lm_card = pseudorandom_element(valid_lm_cards, 'lime' .. G.GAME.round_resets.ante)
    if lm_card then
        G.GAME.current_round.kls_lm_card.suit = lm_card.base.suit
    end
end

SMODS.Joker {
	key = "mint",
	config = { extra = { xmult = 1, xmult_gain = 0.05 } },
	rarity = 2,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 4, y = 2 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
                xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain * G.GAME.hands[context.scoring_name].played
			}
		end
	end
}

SMODS.Joker {
	key = "lavender",
	config = { extra = { dollars = 0 } },
	rarity = 1,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 1, y = 2 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
        local jleft, jright
        if card.area and card.area == G.jokers then -- note: do not delete the doubling. the grouping is (card.area) and (card.area == G.jokers).
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    jleft = G.jokers.cards[i - 1]
                    jright = G.jokers.cards[i + 1]
                end
            end
        end
        local left_cost = (jleft and jleft.sell_cost) or 0
        local right_cost = (jright and jright.sell_cost) or 0
        card.ability.extra.dollars = math.ceil((left_cost + right_cost) / 2)
		return { vars = { card.ability.extra.dollars } }
	end,
	calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars
    end
}

SMODS.Joker {
	key = "cream",
	config = { extra = {  } },
	rarity = 2,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 0, y = 2 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	calculate = function(self, card, context)
        local totalid = 0
        if context.individual and context.cardarea == G.play then
            for _, scored_card in ipairs(context.scoring_hand) do
                if not SMODS.has_no_rank(scored_card) then
                    totalid = totalid + scored_card:get_id()
                end
            end
            context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) + math.ceil(totalid / 5)
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS
        }
        end
    end
}

SMODS.Joker {
	key = "cobalt",
	config = { extra = { price = 5 } },
	rarity = 2,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 0, y = 3 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.price } }
	end,
	calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            local chosen_joker = pseudorandom_element(G.jokers.cards, 'cobalt')
            chosen_joker.ability.extra_value = chosen_joker.ability.extra_value + card.ability.extra.price
            chosen_joker:set_cost()
            return {
                message = localize('k_val_up'),
                colour = G.C.MONEY
            }
        end
    end
}

SMODS.Joker {
	key = "cyan",
	config = { extra = { dollars = 6 } },
	rarity = 2,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 1, y = 3 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.dollars } }
	end,
    calculate = function(self, card, context)
		if context.joker_main and G.GAME.hands[context.scoring_name].played <= 1 then
			return {
                dollars = card.ability.extra.dollars
			}
		end
	end
}

SMODS.Joker {
	key = "tea_green",
	config = { extra = { xmult = 1 } },
	rarity = 2,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 2, y = 3 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
        local card_index
        if card.area and card.area == G.jokers then -- note: do not delete the doubling. the grouping is (card.area) and (card.area == G.jokers).
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    card_index = i
                    return {
                        vars = { card.ability.extra.xmult, math.max(1, #G.jokers.cards - (card_index or 1) + 1) }
                    }
                end
            end
        else
            return {
                vars = { card.ability.extra.xmult, 1 }
            }           
        end
	end,
    calculate = function(self, card, context)
		if context.joker_main and card.area and card.area == G.jokers then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    local card_index = i
                    return {
                        xmult = math.max(1, #G.jokers.cards - (card_index or 1) + 1)
                    }
                end
            end
		end
	end
}

SMODS.Joker {
	key = "plum",
	config = { extra = { xmult = 5 } },
	rarity = 2,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 3, y = 3 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
        local rank1 = (G.GAME.current_round.kls_pm_card_1 or {}).rank or 'Ace'
        local rank2 = (G.GAME.current_round.kls_pm_card_2 or {}).rank or 'Ace'
        local rank3 = (G.GAME.current_round.kls_pm_card_3 or {}).rank or 'Ace'
		return { vars = { card.ability.extra.xmult, rank1, rank2, rank3 } }
	end,
	calculate = function(self, card, context)
        if context.joker_main then
            local ranks = {}
            for k, v in pairs(context.scoring_hand) do
                ranks[v:get_id()] = true
            end
            if ranks[G.GAME.current_round.kls_pm_card_1.id] and ranks[G.GAME.current_round.kls_pm_card_2.id] and ranks[G.GAME.current_round.kls_pm_card_3.id] then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            return {
                message = localize('k_reset'),
                colour = G.C.MULT
            }
        end
    end
}

local function reset_kls_plum_rank()
    G.GAME.current_round.kls_pm_card_1 = { rank = 'Ace' }
    G.GAME.current_round.kls_pm_card_2 = { rank = '2' }
    G.GAME.current_round.kls_pm_card_3 = { rank = '3' }
    local valid_pm_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_rank(playing_card) then
            valid_pm_cards[#valid_pm_cards + 1] = playing_card
        end
    end
    local pm_card_1 = pseudorandom_element(valid_pm_cards, 'plum1_' .. G.GAME.round_resets.ante)
    local pm_card_2 = pseudorandom_element(valid_pm_cards, 'plum2_' .. G.GAME.round_resets.ante)
    local pm_card_3 = pseudorandom_element(valid_pm_cards, 'plum3_' .. G.GAME.round_resets.ante)
    if pm_card_1 then
        G.GAME.current_round.kls_pm_card_1.rank = pm_card_1.base.value
        G.GAME.current_round.kls_pm_card_1.id = pm_card_1.base.id
    end
    if pm_card_2 then
        G.GAME.current_round.kls_pm_card_2.rank = pm_card_2.base.value
        G.GAME.current_round.kls_pm_card_2.id = pm_card_2.base.id
    end
    if pm_card_3 then
        G.GAME.current_round.kls_pm_card_3.rank = pm_card_3.base.value
        G.GAME.current_round.kls_pm_card_3.id = pm_card_3.base.id
    end
end

SMODS.Joker {
	key = "brass",
	config = { extra = { mult = 0, mult_gain = 2 } },
	rarity = 2,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 4, y = 3 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain, card.ability.extra.mult + card.ability.extra.mult_gain * G.GAME.round } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
                mult = card.ability.extra.mult + card.ability.extra.mult_gain * G.GAME.round
			}
		end
	end
}

SMODS.Joker {
	key = "fern",
	config = { extra = { mult = 5, odds = 3 } },
	rarity = 1,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 0, y = 4 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds, "kls_fern_c")
        return { vars = { card.ability.extra.mult, num, den, card.ability.extra.odds} }
    end,
    
}

SMODS.Joker {
	key = "icely",
	config = { extra = { xmult = 1, xmult_gain = 1.5} },
	rarity = 4,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 3, y = 4 },
    soul_pos = { x = 4, y = 4 },
	cost = 20,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain} }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult
			}
		end

		if context.selling_card and context.card.ability.set == "Joker" and context.card ~= card and not context.blueprint and context.main_eval and context.card.config.center.original_mod == SMODS.Mods["KLS"] then
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
			return {
				message = localize { type = "variable", key = "a_xmult", vars = { card.ability.extra.xmult } },
				colour = G.C.MULT,
				card = card
			}
		end
	end
}

SMODS.Joker {
	key = "daniyar",
	config = { extra = { xmult = 1, xmult_gain = 0.75} },
	rarity = 4,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 1, y = 4 },
    soul_pos = { x = 2, y = 4 },
	cost = 20,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult
			}
		end

        if context.after and not context.blueprint then
            local wild = {}
            for _, scored_card in ipairs(context.scoring_hand) do
                if SMODS.has_enhancement(context.other_card, "m_wild") and not scored_card.debuff and not scored_card.daniyared then
                    wild[#wild + 1] = scored_card
                    scored_card.daniyared = true
                end
            end
            SMODS.destroy_cards(wild)
        end
	end
}

function daniyar_check(card, suit)
    if (card.base.suit == "Hearts" or card.base.suit == "Diamonds") and (suit == "Hearts" or suit == "Diamonds") then
        return true
    end
    return false
end

local card_is_suit_ref = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
    local ret = card_is_suit_ref(self, suit, bypass_debuff, flush_calc)
    if not ret and not SMODS.has_no_suit(self) and next(SMODS.find_card("j_kls_daniyar")) then
        return daniyar_check(self, suit)
    end
    return ret
end


function SMODS.current_mod.reset_game_globals(run_start)
    reset_kls_magenta_rank()
    reset_kls_lime_suit()
    reset_kls_plum_rank()
end