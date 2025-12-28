#!/bin/bash
AMX="/usr/bin/amixer -c 0"
LAST_STATE="none"

echo "------------------------------------------"
echo " Monitorowanie: Tryb Stabilny (Głośniki/HP)"
echo "------------------------------------------"

apply_speaker_settings() {
    # Twoja sprawdzona sekcja budzenia
    $AMX sset 'IF1 DAC1 L' on 2>/dev/null
    $AMX sset 'IF1 DAC1 R' on 2>/dev/null
    $AMX sset 'DAC1 MIXL DAC1' on 2>/dev/null
    $AMX sset 'DAC1 MIXR DAC1' on 2>/dev/null
    $AMX sset 'Stereo DAC MIXL DAC L1' on 2>/dev/null
    $AMX sset 'Stereo DAC MIXR DAC R1' on 2>/dev/null
    $AMX sset 'SPK MIXL DAC L1' on 2>/dev/null
    $AMX sset 'SPK MIXR DAC R1' on 2>/dev/null
    $AMX sset 'Speaker ClassD' 7 2>/dev/null
    $AMX sset 'Speaker Channel' on 2>/dev/null
    $AMX sset 'DAC1' 80% unmute 2>/dev/null
    $AMX sset 'Speaker' 80% unmute 2>/dev/null
    wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 2>/dev/null
}

while true; do
    RAW_VAL=$($AMX contents | grep -A 2 "Headphone Jack" | grep "values=" | cut -d'=' -f2)
    
    if [[ "$RAW_VAL" == *"on"* ]]; then
        CURRENT="on"
    else
        CURRENT="off"
    fi

    if [ "$CURRENT" != "$LAST_STATE" ]; then
        if [ "$CURRENT" == "on" ]; then
            echo "[$(date +%T)] --- TRYB SŁUCHAWEK ---"
            $AMX sset 'Speaker Channel' off 2>/dev/null
            $AMX sset 'HPO MIX DAC1' on 2>/dev/null
            $AMX sset 'HPOVOL L' unmute 2>/dev/null
            $AMX sset 'HPOVOL R' unmute 2>/dev/null
            $AMX sset 'Headphone' 30,30 on 2>/dev/null
        else
            echo "[$(date +%T)] --- TRYB GŁOŚNIKÓW (Budzenie + Weryfikacja) ---"
            # Pierwsze uderzenie
            apply_speaker_settings
            
            # Weryfikacja przez 2 sekundy (zapobiega nadpisaniu przez PipeWire)
            for i in {1..4}; do
                sleep 0.5
                apply_speaker_settings
            done
        fi
        LAST_STATE="$CURRENT"
    fi
    sleep 0.5
done
