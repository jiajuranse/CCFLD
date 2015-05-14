fout = fopen('fit.txt', 'w');
fprintf(fout, '%d %f\n', size(fit.beta,1), fit.a0);
for i=1:size(fit.beta,1)
    fprintf(fout, '%f ', fit.beta(i));
end
fprintf(fout, '\n');
for i=1:size(offset,2)
    fprintf(fout, '%f ', offset(i));
end
fprintf(fout, '\n');
for i=1:size(offset,2)
    fprintf(fout, '%f ', scale(i));
end
fclose(fout);