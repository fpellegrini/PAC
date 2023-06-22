filt.low=1;
filt.high = 16;
high = [14 18];
low = 3;

[bl al] = butter(4, (low)/fs*2,'low');
[bh ah] = butter(3, (high)/fs*2);

for oroi = 1:4
    xl(oroi,:) = filtfilt(bl, al, double(data(oroi,:)));
    amp(oroi,:) = abs(hilbert(filtfilt(bh, ah, double(data(oroi,:)))));
end

lf = reshape(xl,[4,np,nep]);
hf = reshape(amp,[4,np,nep]);

%% A iroi lf to jroi hf
u = 3; 
iroi = rc(u,1);
jroi = rc(u,2);
lf_ = lf(iroi,:,:);
hf_ = hf(jroi,:,:);
d = cat(1,lf_,hf_);
[~,~,~,bas] = fp_pac_bispec(d,fs,filt);
bas = bas(:,:,1);
bas
%% B jroi lf to iroi hf 
u = 3; 
iroi = rc(u,1);
jroi = rc(u,2);
lf_ = lf(jroi,:,:);
hf_ = hf(iroi,:,:);
d = cat(1,hf_,lf_);
[~,~,~,bas] = fp_pac_bispec(d,fs,filt);
bas = bas(:,:,1);
bas
%% C
u = 3;
iroi = rc(u,1);
jroi = rc(u,2);
lf_ = data(iroi,:,:);
hf_ = data(jroi,:,:);
d = cat(1,lf_,hf_);
[~,~,~,bas] = fp_pac_bispec(d,fs,filt);
bas = bas(:,:,1);
bas

