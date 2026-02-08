function d = mahalPts(pts,mu,S)
    dif = pts - mu;
    d = sum((dif / S) .* dif,2);
end

