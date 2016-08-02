function [outlet] = FourierRecognition(testcase, threshold, windowsize)
% Recognizes where the voice in a WAV file begins based on the chosen density
% and window size using the windowed Fourier transform.

% performing analysis
[recording, samplerate, nbits] = wavread(testcase);
limit = length(recording);
tic
outlet = winfourier(recording, hamming(windowsize), windowsize, threshold/10);
fprintf('%.4f\n', 10*(mean(outlet) + std(outlet)));
toc

% --- WINDOWED FOURIER TRANSFORM ----------------------------------------------
function [presence] = winfourier(signal, window, windowsize, threshold)
% Recognizes if there is a voice signal for each window using the FFT
limit = length(signal);
presence = [];

% maybe I should use file structures? If that is the case, work with queues
% and incorporate the padding logic.
n = 1;
while n < limit - windowsize
    % constructing window
    term = [];
    for m = 1:windowsize
        if n + m < limit
            term(m) = window(m) * signal(n+m);
        else
            return
        end
    end

    % applying threshold
    result = 0;
    if wfft(term) > threshold
        result = 1;
    end
    presence(n) = result;
    n = n + windowsize;
end

function [result] = wfft(window)
result = mean(abs(real(fft(window))));
