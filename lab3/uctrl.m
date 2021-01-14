function [uk] = uctrl(uk_1, ek, ek_1, ek_2, KP, KI, KD, Ts)
    uk = uk_1 + KP*(ek-ek_1) + (1/2)*KI*Ts*(ek+ek_1) + (KD/Ts)*(ek-(2*ek_1)+ek_2);
    uk = max(min(uk,5),0);
end

