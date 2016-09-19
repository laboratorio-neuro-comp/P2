function [analysis] = main()
% Callback to run button

% Loading voice signal
filename = 'data/voicerecognition.wav';
[record, fs, nbits] = wavread(filename);
%clc;
figure;
plot(1:length(record), record);

%Just trying to see what happens with the old approach
windowsize = 128;
[record, queue] = update_queue(record, windowsize);
windows = [];
analysis = [];
n = 1;

while length(queue) > 0
	% TODO Analyse window

	% new lines from here ...
	[b, a] = butter(2, [80, 260]/(fs/2));
	% H(s) = s^2/(s^2 + 20*s + 6400)
	% Transfer function for a bandpass filter with
	% w0 = 80Hz and w1 = 260 Hz
	analysis(:, n) = filter(b, a, queue);
%	if n ==1
%		figure;
%		plot(1:length(analysis), analysis);
%	end
	% ... till here

	%windows(:, n) = wfft(queue); % WARNING might destroy memory
	n = n+1; % hehehe
	[record, queue] = update_queue(record, windowsize);
end

%figure;
%surf(real(windows));
figure;
surf(analysis);