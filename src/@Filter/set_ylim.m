function [av, RMS, prc, conv_time, conv_i] = set_ylim(x_vec, y_vec, sigma_est, ylims)

conv_i = floor(length(y_vec)/5);
RMS    = sqrt(mean(y_vec(conv_i:end).^2));
conv_i = get_iconv(y_vec, RMS, 100);
av     = mean(y_vec(conv_i:end));
sigma  = std(y_vec(conv_i:end));
RMS    = sqrt(mean(y_vec(conv_i:end).^2));


if nargout > 2
    prc = sum(abs(y_vec) <= 3*sigma_est)/length(y_vec)*100;
    if nargout > 3
        conv_time = x_vec(conv_i);
        if isdatetime(conv_time)
            conv_time = seconds(conv_time - x_vec(1));
        else
            conv_time = (conv_time - x_vec(1));
        end
    end
end

if nargin>3
    if isempty(ylims)
        if sigma ~= 0 && ~isnan(sigma)
            if all(y_vec>=0)
                limsy = get(gca,'YLim');
                ylims = [limsy(1), av+10*sigma];
            elseif all(y_vec<=0)
                limsy = get(gca,'YLim');
                ylims = [av-10*sigma, limsy(2)];
            else
                ylims = av+10*[-sigma, sigma];
            end
        end
    end
end

if ~isempty(ylims)
    set(gca, 'Ylim', ylims);
end

end

function i_conv = get_iconv(y_vec, RMS, n)
    i_conv = find(abs(y_vec) <= RMS/2, n);
    if isempty(i_conv)
        i_conv = find(abs(y_vec) <= RMS, n);
    end
    while length(i_conv)~=1
        n      = ceil(n/2);
        dif    = diff(i_conv);
        if isempty(dif)
            i_conv = 1;
            break;
        end
        if ~any(dif==1)
            i_conv = i_conv(1);
            break;
        end
        i_conv = i_conv(find(dif==1, n));

    end
end

