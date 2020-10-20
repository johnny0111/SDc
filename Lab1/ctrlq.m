function uk = ctrlq(B, F, G, P, Q, R, u1, u2, u3, y1, y2, Yd)
    pbfu = conv(conv(P,B),F);
    ru = (R/B(1)) * R;
    pgy = -conv(P,G);
    uk = ((pbfu(1) + ru)^(-1)) * (pgy(1)*y1 + pgy(2)*y2 + Q*Yd + pbfu(2)*u1 + pbfu(3)*u2 + pbfu(4)*u3);
end