function ov = ellipseOverlap(mu1,S1,mu2,S2,alpha)
% Return fraction of area of ellipse1 overlapped by ellipse2
    [X,Y] = meshgrid(linspace(min([mu1(1),mu2(1)])-3*sqrt(max(S1(1,1),S2(1,1))), ...
                              max([mu1(1),mu2(1)])+3*sqrt(max(S1(1,1),S2(1,1))),50), ...
                     linspace(min([mu1(2),mu2(2)])-3*sqrt(max(S1(2,2),S2(2,2))), ...
                              max([mu1(2),mu2(2)])+3*sqrt(max(S1(2,2),S2(2,2))),50));
    pts = [X(:),Y(:)];
    Q1 = mahalPts(pts,mu1,S1);
    Q2 = mahalPts(pts,mu2,S2);
    in1 = Q1 <= alpha; in2 = Q2 <= alpha;
    ov  = sum(in1 & in2) / max(1,sum(in1));
end

