function [] = set_datetimeTicks(axis, x_vec)
    if isdatetime(x_vec(1))
        limsx=get(axis,'XLim');
        set(gca,'Xlim',[x_vec(1), limsx(2)]);
        dt = (limsx(2)-x_vec(1))/6;
        if dt < hours(1)
            if dt < minutes(1)
                unit = 'seconds';
            else
                unit = 'minutes';
            end
        else
            unit = 'hours';
        end
        xticks(dateshift(x_vec(1), 'end', unit(1:end-1)):round(dt, unit):limsx(2));
    end
end

