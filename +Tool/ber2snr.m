function snr = ber2snr(ber)
    snr = 10 * log10((erfcinv(2 * ber))^2);
end

