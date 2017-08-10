function [ recomList ] = kNN_user_based_recom ( u, R, k, sim )
    % return list of items and predicted rating for user u
    % u - user
    % R - ratings matrix
    % k - number of neighbours
    % sim - function to calculate cimilarity between users
    n = size(R,2);
    mean_userRates = sum(R, 2)./sum(R~=0, 2);
    S = sim( R );
    [~, N] = sort(S,2,'descend');
    N = N(:,1:k);
    P = zeros(n,1);
    for i = 1:n
        if R(u,i) == 0
            P(i) = mean_userRates(u) + ...
            dot( (R(N(u,:),i)~=0)' .* S(u,N(u,:)), R(N(u,:),i) - mean_userRates(N(u,:)) ) / norm( (R(N(u,:),i)~=0)' .* S(u,N(u,:)), 1 );
        end
    end
    [~, recomList] = sort(P,'descend');
    recomList = recomList(1:sum(P>0));
    recomList = horzcat(recomList,P(recomList));
end