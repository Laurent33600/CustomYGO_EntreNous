-- Soupçon de la Fiole Disparue
local s,id=GetID()
function s.initial_effect(c)
    -- Search or Banish
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.filter(c)
    return c:IsSetCard(3856) and c:IsType(TYPE_TRAP) and (c:IsAbleToHand() or c:IsAbleToRemove())
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        local op=0
        if tc:IsAbleToHand() and tc:IsAbleToRemove() then
            op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
        elseif tc:IsAbleToHand() then
            op=Duel.SelectOption(tp,aux.Stringid(id,1))
        else
            op=Duel.SelectOption(tp,aux.Stringid(id,2))
        end
        if op==0 then
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
        else
            Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
        end
    end
end

-- Add descriptions
if not s.custom_strings_loaded then
    s.custom_strings_loaded = true
    aux.Stringid = function(id, index)
        local custom_strings = {
            [0] = "Lorsque cette carte est invoquée Normalement : ajoutez une Carte Piège 'Fiole Disparue' de votre Deck à votre Main, ou bannissez-la.",
            [1] = "Ajouter à la main",
            [2] = "Bannir"
        }
        return custom_strings[index]
    end
end
