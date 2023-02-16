function [ X ] = shift_timeseries( X, signal_position, n_shifts )
% signal_position can have values between 1 and n_shifts
% from /Hendrik_surrogates/shift_timeseries.m
  if size(X, 1) ~= 2
    X = [];
    print_log('Only use this for 2 dimensional timeseries.');
    return
  end

  T = floor(size(X,2)/(n_shifts+1));

  X(2,:) = circshift(X(2,:),signal_position*T,2);

end
